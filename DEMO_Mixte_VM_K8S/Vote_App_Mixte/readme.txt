# Sidecar telegraf
# ----------------
#
# Source Template:     https://raw.githubusercontent.com/wavefrontHQ/wavefront-kubernetes/master/telegraf-sidecar/telegraf-sidecar.yaml
#
# Pensez a modifier les limits du container telegraf 'le defaut n'est pas suffisant'  => ca ne marche pas avec les defaults
#  => pour le savoir, regarder la log du container telegraf pour voir si y a un pb de connexion ou une collecte pas fini
#
#
# detail du pod Frontend:
# ----------------------
# LE POD contient 2 contrainers:
#   - telegraf:
#       entrypoint:  /entrypoint.sh        =>  "telegraf --config /etc/telegraf/telegraf.conf --config-directory /etc/telegraf/telegraf.d"    =>  s'execute en process ID=1   (ce n'est pas un service)
#   - vote-frontend:
#       entrypoint:/entrypoint.sh
#  
# Les deux containers partagent le volume: /var/log/nginx
# 
#
#
# TEST WAVEFRONT PROXY
# --------------------
# echo -e "alexh2.metric 1 source=test_host\n" | nc vra-008178.cpod-vrealize.az-fkd.cloud-garage.net 2878
#
#
# RECHERCHE DE LA METRIQUE DANS WAVEFRONT
# ---------------------------------------
# rechercher la metrique qui commence par "alexh2.", par exemple "alexh2.nginx.handled"
#
#
#
# SI LE TOKEN WAVEFRONT A EXPIRE
# ------------------------------
# - Supprimer le container docker   "docker stop" puis "docker rm"
# - Creer un nouveau container avec le bon token
#   docker run -d \
#     -e WAVEFRONT_URL=https://vmware.wavefront.com/api/ \
#     -e WAVEFRONT_TOKEN=7ecxxxxx-xxxx-xxxx-xxxx-xxxxxxxx938b \
#     -e JAVA_HEAP_USAGE=512m \
#     -p 2878:2878 \
#     -p 4242:4242 \
#     --restart always \
#     wavefronthq/proxy:latest
#






