# cryptoPKI_CA_CAint_apache

### Examen : 

Implémenter une solution PKI :

• Créer une paire de clés et un certificat autosigné pour l'autorité de certification
« root».

• Créer une paire de clés et un certificat électronique signé par l'autorité de certification « root » pour obtenir une autorité de certification intermédiaire (chaîne de certification.)

• Créer une paire de clés et un certificat électronique validé par l'AC « intermédiaire»
pour un serveur.

• Présenter les certificats.

• Documenter (faire un fichier ms-word) des commandes utilisées.

• Implémenter dans un serveur web (Nginx ou Apache) le protocole HTTPS avec le certificat du serveur.

• Montrer son fonctionnement à l'aide d'une connexion avec un navigateur




Étape	Objectif	Status	Détails
1️⃣	Créer une paire de clés + certificat autosigné pour la Root CA	✅	Tu as généré ca.key.pem + ca.cert.pem avec openssl req -x509
2️⃣	Créer paire de clés + CSR pour l'intermédiaire	✅	Tu as généré intermediate.key.pem + intermediate.csr.pem
2️⃣ (bis)	Signer le certificat intermédiaire avec la Root CA	✅	Tu as signé avec openssl x509 -req et utilisé une extension intext.cnf
3️⃣	Créer paire de clés + CSR pour le serveur	✅	Tu as généré server.key.pem + server.csr.pem
3️⃣ (bis)	Signer le certificat serveur avec l'AC intermédiaire	✅	Tu as signé avec openssl x509 -req et utilisé server_ext.cnf
4️⃣	Créer la chaîne de certification complète (fullchain.pem)	✅	Tu as concaténé : server.cert.pem + intermediate.cert.pem + ca.cert.pem
5️⃣	Implémenter dans Apache le certificat serveur	✅	Apache utilise bien fullchain.pem et server.key.pem (on a vu le HTTPS fonctionner)
6️⃣	Tester dans un navigateur (localhost, avec avertissement)	✅	Firefox affiche bien l’erreur de "certificat inconnu", ce qui est attendu
