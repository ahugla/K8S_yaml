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
# echo -e "alexhtest.metric 1 source=test_host\n" | nc vra-008178.cpod-vrealize.az-fkd.cloud-garage.net 2878
#
