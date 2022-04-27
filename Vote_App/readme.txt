
v1.0 : fond gris 
v1.1 : fond gris avec /basic_status activé (pour telegraf monitoring)
v2.0 : fond vert
v2.1 : fond vert avec /basic_status activé (pour telegraf monitoring)




Basé sur :  https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough
       Front: nginx: mcr.microsoft.com/azuredocs/azure-vote-front:v1
       Back:  redis: mcr.microsoft.com/oss/bitnami/redis:6.0.8

 frontend : nginx
 backend  : redis:6.0.8

 Acces via service K8S :   http://[IP LB]

 Appli dans:  /app
 Fichier de conf : /app/config_file.cfg  :   permet d'afficher le nom du pod ou pas avec la variable "hostname" et de fixer la version
 Configurer l'affichage de la version de l'appli dans le portail web : dans /app/main.py

 versioning:
   dans: - /app/config_file.cfg
	 - /app/main.py


 Installer vim dans le container:
  - apt update
  - apt install vim

 kubectl scale deployment vote-frontend --replicas=2


 ajout dans /etc/nginx/nginx.conf

	server {
	    listen 80;
	    location / {
	        try_files $uri @app;
	    }
	    location @app {
	        include uwsgi_params;
	        uwsgi_pass unix:///tmp/uwsgi.sock;
	    }
	    location /static {
	        alias /app/static;
	    }
	    location /basic_status {
	       stub_status; 
	     }
	}



