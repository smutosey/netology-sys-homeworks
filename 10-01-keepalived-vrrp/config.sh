# repo override
#ru
sed -i 's/us.archive.ubuntu.com/mirror.linux-ia64.org/g' /etc/apt/sources.list

useradd $1 -s /bin/bash -d /home/test
mkdir /home/test
chown -R test:test /home/test
echo ''$1'    ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers

usermod --password $(openssl passwd -6 $2) root
usermod --password $(openssl passwd -6 $2) $1

if [ $3 == "true" ]; then apt-get update -y && apt-get upgrade -y && sudo apt-get autoremove; else echo '$3'=$3; fi

rm -Rf /etc/hosts
echo "127.0.0.1	localhost.localdomain	localhost" >> /etc/hosts
echo "$5	$4.localdomain	$4" >> /etc/hosts

echo "************* Keepalived Install *************"
sudo apt-get install -f -y keepalived net-tools
echo "\$6=$6"
if [[ $6 == "192.168.1.1" ]]
then
cat > /etc/keepalived/keepalived.conf << "EOF"
vrrp_instance nedorezov {
    state MASTER
    interface eth2
    virtual_router_id 10
    priority 100
    advert_int 4
    authentication {
        auth_type test
        auth_pass test
    }
    unicast_peer {
        192.168.1.2
    }
    virtual_ipaddress {
        192.168.1.99 dev eth2 label eth2:vip
    }
}
EOF
else
cat > /etc/keepalived/keepalived.conf << "EOF"
vrrp_instance nedorezov {
    state BACKUP
    interface eth2
    virtual_router_id 10
    priority 90
    advert_int 4
    authentication {
        auth_type test
        auth_pass test
    }
    unicast_peer {
        192.168.1.1
    }
    virtual_ipaddress {
        192.168.1.99 dev eth2 label eth2:vip
    }
}
EOF
fi
sudo systemctl restart keepalived
sudo systemctl enable keepalived
sudo systemctl status keepalived
echo "************* Keepalived Install complete *************"