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

sudo timedatectl set-timezone "Asia/Novosibirsk"
sudo timedatectl set-ntp true

rm -Rf /etc/hosts
echo "127.0.0.1	localhost.localdomain	localhost" >> /etc/hosts
echo "$5    $4" >> /etc/hosts


echo "************* Docker Install *************"
sudo apt-get update -y
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo usermod -a -G docker $1

echo "************* Start MySQL container *************"
sudo cp /tmp/docker-compose.yml /home/$1/
sudo chown -R $1:$1 /home/$1/docker-compose.yml

sudo docker compose -f /home/$1/docker-compose.yml up -d 
