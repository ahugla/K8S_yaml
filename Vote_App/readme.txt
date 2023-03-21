
v1.0 : fond gris 
v1.1 : fond gris avec /basic_status activé (pour telegraf monitoring)
v2.0 : fond vert
v2.1 : fond vert avec /basic_status activé (pour telegraf monitoring)




Basé sur :  https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough
       Front: nginx: mcr.microsoft.com/azuredocs/azure-vote-front:v1
       Back:  redis: mcr.microsoft.com/oss/bitnami/redis:6.0.8


 frontend : nginx
 backend  : redis:6.0.8




FRONT-END
---------

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


 ajout dans /etc/nginx/nginx.conf:
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




BACK-END
--------

Exposer redis pour utiliser RedisInsight:
 	- exposer le service backend:  kubectl expose deployment vote-backend --type=LoadBalancer --name=vote-backend-svc
 	- access : IP_LB:6379   (dans RedisInsight: pas de login/pass, tout unckeck)

installation de redis:  
	dnf -y install redis
	systemctl enable --now redis
	# Enable Redis Service to listen on all interfaces - By default, Redis service listens on 127.0.0.1.
	ss -tunelp | grep 6379
	# Accepter les connections remotes
	sed -i -e 's/bind 127.0.0.1/bind 0.0.0.0/g'  /etc/redis.conf    
	systemctl  restart redis
	


RELATION FRONT-END - BACKEND
----------------------------
Sur le frontend, dans le fichier "main.py", le pod front-end pointe vers le backend via la variable "redis_server" qui prend la valeur de la variable d'environnement "REDIS".
	# Redis configurations
	redis_server = os.environ['REDIS']

Dans le yaml du pod frontend, on definit la variable d'env 'REDIS'= vote-backend. 
	env:
    - name: REDIS
      value: "vote-backend"
Ainsi dasn le pod :
	root@vote-frontend-v1:/app# env | grep REDIS
	REDIS=vote-backend

OR 'vote-backend' est enregistré dans le CoreDNS avec le cluster IP du service redis  =>  il y a bien resolution de vote-backend en cluster IP du service redis

Si on change la variable d'environnement defini dans le yaml par une IP on peut pointer vers un autre redis, physique.
