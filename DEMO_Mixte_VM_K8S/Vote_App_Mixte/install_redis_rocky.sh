#!/bin/bash


# PARAMETERS
# ----------
WAVEFRONT_PROXY=e7788df6e9d3                    # ID du container docker si le proxy est en container
echo "WAVEFRONT_PROXY = " $WAVEFRONT_PROXY



# INSTALL AND CONFIGURE REDIS
# ---------------------------

cd /tmp

#dnf module list redis
dnf -y install redis

systemctl enable --now redis

# Enable Redis Service to listen on all interfaces - By default, Redis service listens on 127.0.0.1.
ss -tunelp | grep 6379

# Accepter les connections remotes
# Pour voir la config en masquant les commentaires:    grep ^[^#]  /etc/redis.conf
# OLD : sed -i -e 's/bind 127.0.0.1/bind 0.0.0.0/g'  /etc/redis.conf    
# default :  bind 127.0.0.1 -::1 
sed -i -e 's/bind 127.0.0.1 -::1/bind * -::*/g'  /etc/redis/redis.conf


systemctl  restart redis
systemctl status redis


#redis-cli 
#127.0.0.1:6379> ping
#PONG



# Load Redis environment variables
. /opt/bitnami/scripts/redis-env.sh

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/libredis.sh


print_welcome_page

if [[ "$*" = *"/opt/bitnami/scripts/redis/run.sh"* || "$*" = *"/run.sh"* ]]; then
    info "** Starting Redis setup **"
    /opt/bitnami/scripts/redis/setup.sh
    info "** Redis setup finished! **"
fi

echo ""
exec "$@"

grep -rnl /* -e 'Cats'
	/bitnami/redis/data/appendonly.aof
	/bitnami/redis/data/dump.rdb






# INSTALL TELEGRAF & ENABLE MONITORING BY WAVEFRONT
# -------------------------------------------------

cd /tmp

# ajout du repo
cat <<EOF | sudo tee /etc/yum.repos.d/influxdata.repo
[influxdata]
name = InfluxData Repository - Stable
baseurl = https://repos.influxdata.com/stable/\$basearch/main
enabled = 1
gpgcheck = 1
gpgkey = https://repos.influxdata.com/influxdata-archive_compat.key
EOF

dnf repolist

dnf install -y telegraf

# config pour redis
cat <<EOF > /etc/telegraf/telegraf.d/redis.conf
[[inputs.redis]]
  ## specify servers via a url matching:
  ##  [protocol://][:password]@address[:port]
  ##  e.g.
  ##    tcp://localhost:6379
  ##    tcp://:password@192.168.99.100
  ##
  ## If no servers are specified, then localhost is used as the host.
  ## If no port is specified, 6379 is used
  servers = ["tcp://`hostname -f`:6379"]
EOF

# config pour wavefront
echo " " >> /etc/telegraf/telegraf.conf
echo " " >> /etc/telegraf/telegraf.conf
echo " " >> /etc/telegraf/telegraf.conf
echo "# CONFIG WAVEFRONT"    >> /etc/telegraf/telegraf.conf
echo "[[outputs.wavefront]]" >> /etc/telegraf/telegraf.conf
echo "  host = \"vra-008178.cpod-vrealize.az-fkd.cloud-garage.net\"   #  proxy URL"  >> /etc/telegraf/telegraf.conf
echo "  port = 2878                                                   #  proxy port" >> /etc/telegraf/telegraf.conf
echo "  prefix = \"\"                                                 #  optionnel"  >> /etc/telegraf/telegraf.conf

systemctl enable telegraf
systemctl start telegraf















