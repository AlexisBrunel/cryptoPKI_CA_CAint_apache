ca.key.pem	🔐 Clé privée de la CA racine	C’est le cœur de la confiance. Elle est utilisée pour signer les certificats des CA intermédiaires. Elle doit être hautement protégée, idéalement stockée hors ligne.


ca.cert.pem	📜 Certificat autosigné de la CA racine	Identité publique de la CA racine. C’est un certificat autosigné, utilisé pour vérifier toute la chaîne de confiance. Il est distribué aux clients pour leur permettre de valider les certificats.


ca.cert.srl	#️⃣ Numéro de série du dernier certificat signé	Comme pour l’intermédiaire, il est utilisé automatiquement par OpenSSL pour attribuer un numéro de série unique à chaque certificat signé par cette CA.


intext.cnf	⚙️ Fichier de configuration d’extensions X.509	Utilisé lors de la signature du certificat intermédiaire, il contient des directives comme basicConstraints, keyUsage, etc. C’est ce fichier qui permet de définir les capacités du certificat intermédiaire (par exemple : "ce certificat peut signer d'autres certificats").
