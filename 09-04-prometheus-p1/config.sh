# repo override
#ru
sed -i 's/us.archive.ubuntu.com/mirror.linux-ia64.org/g' /etc/apt/sources.list

useradd $1 -s /bin/bash -d /home/test
mkdir /home/test
chown -R test:test /home/test
echo ''$1'    ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers

usermod --password $(openssl passwd -6 $2) root
usermod --password $(openssl passwd -6 $2) $1

if [ $3 == "true" ]; then apt upgrade -y; else echo '$3'=$3; fi

rm -Rf /etc/hosts
echo "127.0.0.1	localhost.localdomain	localhost" >> /etc/hosts
echo "$5	$4.localdomain	$4" >> /etc/hosts


if [[ $4 == 'grafana' ]]
then
echo "*********************** Install and configure Grafana **********************"
echo "\$4=$4"
apt-get update -y
apt-get install -y libfontconfig1
wget https://dl.grafana.com/oss/release/grafana_9.2.4_amd64.deb
dpkg -i grafana_9.2.4_amd64.deb
systemctl enable grafana-server
systemctl start grafana-server
systemctl status grafana-server

elif [[ $4 == 'prometheus' ]]
then
echo "*********************** Install and configure Prometheus **********************"
echo "\$4=$4"
sudo useradd --no-create-home --shell /bin/false prometheus
mkdir /etc/prometheus
if [[ ! -f ./prometheus-2.40.1.linux-386.tar.gz ]]
then
    wget https://github.com/prometheus/prometheus/releases/download/v2.40.1/prometheus-2.40.1.linux-386.tar.gz
fi
tar xvfz prometheus-2.40.1.linux-386.tar.gz
cd prometheus-2.40.1.linux-386
mkdir /var/lib/prometheus
cp ./prometheus promtool /usr/local/bin/
cp -R ./console_libraries /etc/prometheus
cp -R ./consoles /etc/prometheus
cp ./prometheus.yml /etc/prometheus
chown -R prometheus:prometheus /etc/prometheus /var/lib/prometheus
chown prometheus:prometheus /usr/local/bin/prometheus
chown prometheus:prometheus /usr/local/bin/promtool
cat > /etc/systemd/system/prometheus.service << 'EOF' 
[Unit]
Description=Prometheus Service Netology Lesson 9.4 — Nedorezov Aleksandr Sergeevich
After=network.target
[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
--config.file /etc/prometheus/prometheus.yml \
--storage.tsdb.path /var/lib/prometheus/ \
--web.console.templates=/etc/prometheus/consoles \
--web.console.libraries=/etc/prometheus/console_libraries
ExecReload=/bin/kill -HUP $MAINPID Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF
chown -R prometheus:prometheus /var/lib/prometheus
sed -i "s/\"localhost:9090\"/\"localhost:9090\",\"$6:9100\",\"$7:9100\"/g" /etc/prometheus/prometheus.yml && echo "prometheus.yml configured"
sudo systemctl enable prometheus
sudo systemctl start prometheus
sudo systemctl status prometheus

else
echo "********************* Install and configure Node Exporter *********************"
echo "\$4=$4"
sudo useradd --no-create-home --shell /bin/false prometheus
mkdir /etc/prometheus
wget https://github.com/prometheus/node_exporter/releases/\download/v1.4.0/node_exporter-1.4.0.linux-amd64.tar.gz
tar xvfz node_exporter-*.*-amd64.tar.gz
mkdir /etc/prometheus/node-exporter
cp ./node_exporter-*.*-amd64/* /etc/prometheus/node-exporter/
chown -R prometheus:prometheus /etc/prometheus/node-exporter/
cat > /etc/systemd/system/node-exporter.service << 'EOF'
[Unit]
Description=Node Exporter Netology Lesson 9.4 — Nedorezov Aleksandr Sergeevich
After=network.target
[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/etc/prometheus/node-exporter/node_exporter
[Install]
WantedBy=multi-user.target
EOF
systemctl enable node-exporter.service
systemctl start node-exporter.service
systemctl status node-exporter.service
fi