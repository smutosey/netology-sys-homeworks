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
echo "************* Memcached install *************"
echo "******************************************"
apt-get install libevent-dev gcc make -y
wget https://memcached.org/latest
tar -zxf latest && cd memcached*
./configure --prefix=/usr/local/memcached
sudo make && sudo make test && sudo make install

# sudo apt install memcached -y
sudo apt install libmemcached-tools -y
sudo systemctl start memcached

echo "******************************************"
echo "************* Redis install *************"
echo "******************************************"
sudo apt install lsb-release
curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list
sudo apt-get update -y
sudo apt-get install redis -y

sudo systemctl status redis-server
redis-cli -h 127.0.0.1 ping