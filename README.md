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






1️⃣	Créer une paire de clés + certificat autosigné pour la Root CA	✅	

2️⃣	Créer paire de clés + CSR pour l'intermédiaire	✅	

2️⃣ (bis)	Signer le certificat intermédiaire avec la Root CA	✅	

3️⃣	Créer paire de clés + CSR pour le serveur	✅	

3️⃣ (bis)	Signer le certificat serveur avec l'AC intermédiaire	✅

4️⃣	Créer la chaîne de certification complète (fullchain.pem)	✅	

5️⃣	Implémenter dans Apache le certificat serveur	✅	

6️⃣	Tester dans un navigateur (localhost, avec avertissement)	✅	
