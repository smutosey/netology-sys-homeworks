# repo override
#ru
sed -i 's/us.archive.ubuntu.com/mirror.linux-ia64.org/g' /etc/apt/sources.list

useradd $1 -s /bin/bash -d /home/$1
mkdir /home/$1
chown -R $1:$1 /home/$1
echo ''$1'    ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers

usermod --password $(openssl passwd -6 $2) root
usermod --password $(openssl passwd -6 $2) $1

if [ $3 == "true" ]; then apt-get update -y; else echo '$3'=$3; fi
# && apt-get upgrade -y && sudo apt-get autoremove

rm -Rf /etc/hosts
echo "127.0.0.1	localhost.localdomain	localhost" >> /etc/hosts
echo "$5	$4.localdomain	$4" >> /etc/hosts

echo "******************************************"
echo "************* ELASTIC install *************"
echo "******************************************"

echo "deb [trusted=yes] https://mirror.yandex.ru/mirrors/elastic/8/ stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list
sudo apt-get update -y && sudo apt install elasticsearch -y

sudo systemctl daemon-reload 
sudo systemctl enable elasticsearch.service 
sudo systemctl start elasticsearch.service
# sudo systemctl status elasticsearch.service

# ./bin/elasticsearch-reset-password -u elastic

echo "******************************************"
echo "************* KIBANA install *************"
echo "******************************************"
sudo apt install kibana -y
sudo systemctl daemon-reload
sudo systemctl enable kibana.service
sudo systemctl start kibana.service
# sudo systemctl status kibana.service

echo "******************************************"
echo "************* LOGSTASH install *************"
echo "******************************************"
sudo apt install logstash -y
sudo systemctl daemon-reload
sudo systemctl enable logstash.service
# sudo systemctl start logstash.service

echo "******************************************"
echo "************* NGINX install *************"
echo "******************************************"
sudo apt install nginx -y