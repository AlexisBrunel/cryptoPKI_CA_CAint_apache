#!/bin/bash
set -e

# Structure des dossiers
mkdir -p root/{certs,crl,newcerts,private}
mkdir -p intermediate/{certs,crl,csr,newcerts,private}
mkdir -p certs

# Fichiers index et serial pour root et intermediate
touch root/index.txt
echo 1000 > root/serial

touch intermediate/index.txt
echo 1000 > intermediate/serial
echo 1000 > intermediate/crlnumber

# Plus besoin de copier les fichiers de conf openssl.cnf car ils sont déjà en place

# Génération clé privée Root CA
openssl genrsa -out root/private/ca.key.pem 4096

# Certificat Root CA auto-signé
openssl req -config root/openssl.cnf \
    -key root/private/ca.key.pem \
    -new -x509 -days 3650 -sha256 \
    -out root/certs/ca.cert.pem \
    -subj "/C=FR/ST=SomeState/L=SomeCity/O=MyRootCA/OU=OrgRoot/CN=RootCA"

echo "[+] Root CA generated"

# Génération clé privée Intermediate CA
openssl genrsa -out intermediate/private/intermediate.key.pem 4096
chmod 400 intermediate/private/intermediate.key.pem

# CSR Intermediate
openssl req -config intermediate/openssl.cnf \
    -new -sha256 \
    -key intermediate/private/intermediate.key.pem \
    -out intermediate/csr/intermediate.csr.pem \
	-subj "/C=FR/ST=SomeState/L=SomeCity/O=MyRootCA/OU=OrgIntermediate/CN=IntermediateCA"

# Signature du certificat Intermediate par Root CA
openssl ca -config root/openssl.cnf -extensions v3_intermediate_ca \
    -days 1825 -notext -md sha256 \
    -in intermediate/csr/intermediate.csr.pem \
    -out intermediate/certs/intermediate.cert.pem \
    -batch

chmod 444 intermediate/certs/intermediate.cert.pem

echo "[+] Intermediate CA signed by Root CA"

# Génération clé privée serveur
openssl genrsa -out certs/server.key.pem 2048
chmod 400 certs/server.key.pem

# CSR serveur
openssl req -config certs/openssl.cnf \
    -new -sha256 \
    -key certs/server.key.pem \
    -out certs/server.csr.pem \
    -subj "/C=FR/ST=SomeState/L=SomeCity/O=MyServer/OU=OrgServer/CN=localhost"

# Signature du certificat serveur par Intermediate CA
openssl ca -config intermediate/openssl.cnf -extensions server_cert \
    -days 825 -notext -md sha256 \
    -in certs/server.csr.pem \
    -out certs/server.cert.pem \
    -batch

chmod 444 certs/server.cert.pem

echo "[+] Server certificate signed by Intermediate CA"

# Création du fullchain.pem (chaîne complète pour serveur)
cat certs/server.cert.pem intermediate/certs/intermediate.cert.pem root/certs/ca.cert.pem > certs/fullchain.pem

echo "[+] Fullchain.pem created"

echo "==== Tous les certificats et clés sont générés ===="

# ... après génération des certificats

echo "[*] Installation d'Apache2 si besoin"
if ! command -v apache2 >/dev/null 2>&1; then
    sudo apt update
    sudo apt install -y apache2
fi

echo "[*] Activation des modules SSL et rewrite"
sudo a2enmod ssl
sudo a2enmod rewrite

APACHE_SSL_DIR="/etc/apache2/ssl"
sudo mkdir -p $APACHE_SSL_DIR

echo "[*] Copier certificats"
sudo cp certs/server.cert.pem $APACHE_SSL_DIR/server.crt
sudo cp certs/fullchain.pem $APACHE_SSL_DIR/fullchain.pem
sudo cp certs/server.key.pem $APACHE_SSL_DIR/server.key
sudo chmod 600 $APACHE_SSL_DIR/server.key
sudo chmod 644 $APACHE_SSL_DIR/server.crt $APACHE_SSL_DIR/fullchain.pem

APACHE_SSL_CONF="/etc/apache2/sites-available/default-ssl.conf"

echo "[*] Création config Apache SSL"
sudo tee $APACHE_SSL_CONF > /dev/null <<EOF
<VirtualHost *:443>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html

    SSLEngine on
    SSLCertificateFile      $APACHE_SSL_DIR/fullchain.pem
    SSLCertificateKeyFile   $APACHE_SSL_DIR/server.key

    <Directory /var/www/html>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

echo "[*] Activation site SSL"
sudo a2ensite default-ssl

echo "[*] Redémarrage Apache"
sudo systemctl restart apache2

echo "[+] Apache SSL configuré et démarré sur https://localhost"
