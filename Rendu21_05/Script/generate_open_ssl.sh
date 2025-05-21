#!/bin/bash

# Chemins vers les dossiers
ROOT_DIR="./root"
INT_DIR="./intermediate"
CERTS_DIR="./certs"

mkdir -p "$ROOT_DIR" "$INT_DIR" "$CERTS_DIR"

### -------- ROOT CA CONFIG --------
cat > "$ROOT_DIR/openssl.cnf" <<EOF
[ ca ]
default_ca = CA_default

[ CA_default ]
dir               = $ROOT_DIR
certs             = \$dir/certs
crl_dir           = \$dir/crl
new_certs_dir     = \$dir/newcerts
database          = \$dir/index.txt
serial            = \$dir/serial
private_key       = \$dir/private/ca.key.pem
certificate       = \$dir/certs/ca.cert.pem

default_md        = sha256
policy            = policy_strict
email_in_dn       = no
copy_extensions   = copy

[ policy_strict ]
countryName             = match
stateOrProvinceName     = match
organizationName        = match
organizationalUnitName  = optional
commonName              = supplied
emailAddress            = optional

[ req ]
default_bits        = 4096
distinguished_name  = req_distinguished_name
string_mask         = utf8only
default_md          = sha256
x509_extensions     = v3_ca

[ req_distinguished_name ]
countryName         = Country Name (2 letter code)
countryName_default = FR
stateOrProvinceName = State or Province Name
stateOrProvinceName_default = France
localityName        = Locality Name
localityName_default = Paris
0.organizationName  = Organization Name
0.organizationName_default = ESGIAlexis
commonName          = Common Name
commonName_default  = Root CA

[ v3_ca ]
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer
basicConstraints = critical, CA:true
keyUsage = critical, digitalSignature, cRLSign, keyCertSign
EOF
[ v3_intermediate_ca ]
basicConstraints = critical, CA:true, pathlen:0
keyUsage = critical, digitalSignature, cRLSign, keyCertSign
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer




### -------- INTERMEDIATE CA CONFIG --------
cat > "$INT_DIR/openssl.cnf" <<EOF
[ ca ]
default_ca = CA_default

[ CA_default ]
dir               = $INT_DIR
certs             = \$dir/certs
crl_dir           = \$dir/crl
new_certs_dir     = \$dir/newcerts
database          = \$dir/index.txt
serial            = \$dir/serial
private_key       = \$dir/private/intermediate.key.pem
certificate       = \$dir/certs/intermediate.cert.pem

default_md        = sha256
policy            = policy_loose
email_in_dn       = no
copy_extensions   = copy

[ policy_loose ]
countryName             = optional
stateOrProvinceName     = optional
organizationName        = optional
organizationalUnitName  = optional
commonName              = supplied
emailAddress            = optional

[ req ]
default_bits        = 4096
distinguished_name  = req_distinguished_name
string_mask         = utf8only
default_md          = sha256
x509_extensions     = v3_intermediate_ca

[ req_distinguished_name ]
countryName         = Country Name (2 letter code)
countryName_default = FR
stateOrProvinceName = State or Province Name
stateOrProvinceName_default = France
localityName        = Locality Name
localityName_default = Paris
0.organizationName  = Organization Name
0.organizationName_default = ESGIAlexis
commonName          = Common Name
commonName_default  = Intermediate CA

[ v3_intermediate_ca ]
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer
basicConstraints = critical, CA:true, pathlen:0
keyUsage = critical, digitalSignature, cRLSign, keyCertSign
EOF

[ server_cert ]
basicConstraints = CA:FALSE
keyUsage = digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = localhost




### -------- SERVER CONFIG --------
cat > "$CERTS_DIR/openssl.cnf" <<EOF
[ req ]
default_bits        = 2048
prompt              = no
default_md          = sha256
distinguished_name  = dn
req_extensions      = req_ext

[ dn ]
C=FR
ST=France
L=Paris
O=ESGIAlexis
OU=WebServer
CN=localhost

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = localhost
EOF
