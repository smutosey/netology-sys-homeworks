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

rm -Rf /etc/hosts
echo "127.0.0.1	localhost.localdomain	localhost" >> /etc/hosts
echo "$5	$4.localdomain	$4" >> /etc/hosts


echo "************* HAProxy and NGINX Install *************"
sudo apt install haproxy -y
sudo apt install nginx -y

echo "************* HAProxy and NGINX config *************"
cat > /etc/nginx/sites-available/test.conf << "EOF"
server {
    listen 8088;

    server_name nedorezov.netology.com;

    location /ping {
        return 200 'nginx is configured correctly\n';
    }
}
EOF
ln -s /etc/nginx/sites-available/test.conf /etc/nginx/sites-enabled/test.conf


cat > /etc/haproxy/haproxy.cfg << "EOF"
defaults
    mode http
    timeout client 10s
    timeout connect 5s
    timeout server 10s 
    timeout http-request 10s

frontend www
    bind :8080
    http-request set-path /ping
    default_backend web_servers

backend web_servers
    server me localhost:8088
EOF

sudo systemctl restart nginx
sudo systemctl restart haproxy