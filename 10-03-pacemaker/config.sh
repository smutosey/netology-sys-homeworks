# repo override
#ru
sed -i 's/us.archive.ubuntu.com/mirror.linux-ia64.org/g' /etc/apt/sources.list

useradd $1 -s /bin/bash -d /home/test
mkdir /home/test
chown -R test:test /home/test
echo ''$1'    ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers

usermod --password $(openssl passwd -6 $2) root
usermod --password $(openssl passwd -6 $2) $1

if [ $3 == "true" ]; then apt-get update -y; else echo '$3'=$3; fi
# && apt-get upgrade -y && sudo apt-get autoremove



echo "************* DRBD Install *************"
# sudo apt-get update -y
# sudo apt install drbd-utils -y
# sudo modprobe drbd
# echo “drbd” >> /etc/modules

echo "************* Pacemaker, Corosync, PCS Install *************"
sudo apt install pacemaker corosync pcs -y
systemctl enable pcsd
systemctl enable corosync
systemctl enable pacemaker

cat > /etc/hosts << "EOF"
127.0.0.1 localhost
192.168.1.10 nodeone
192.168.1.20 nodetwo
192.168.2.10 nodeone
192.168.2.20 nodetwo
# The following lines are desirable for IPv6 capable hosts
::1 localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
EOF

echo "hacluster:1q2w3e4r" | sudo chpasswd
# service pcsd start
# echo 1q2w3e4r | sudo pcs host auth nodeone nodetwo -u hacluster