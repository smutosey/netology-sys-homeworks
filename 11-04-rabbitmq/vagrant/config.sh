# repo override
#ru
sed -i 's/us.archive.ubuntu.com/mirror.linux-ia64.org/g' /etc/apt/sources.list

useradd $1 -s /bin/bash -d /home/$1
mkdir /home/$1
chown -R $1:$1 /home/$1
echo ''$1'    ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers

useradd ansible -s /bin/bash -d /home/ansible
mkdir /home/ansible
chown -R ansible:ansible /home/ansible
echo 'ansible    ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers

usermod --password $(openssl passwd -6 $2) root
usermod --password $(openssl passwd -6 $2) $1
usermod --password $(openssl passwd -6 $2) ansible

if [ $3 == "true" ]; then apt-get update -y; else echo '$3'=$3; fi
# && apt-get upgrade -y && sudo apt-get autoremove

rm -Rf /etc/hosts
echo "127.0.0.1	localhost.localdomain	localhost" >> /etc/hosts
echo "$5    $4" >> /etc/hosts



if [[ $4 == "controller" ]]
then 
    echo "************* Ansible Install *************"
    echo "192.168.0.231    rmq01" >> /etc/hosts
    echo "192.168.0.232    rmq02" >> /etc/hosts
    echo "192.168.0.233    rmq03" >> /etc/hosts
    sudo apt update -y && sudo apt upgrade -y
    sudo apt install python3-pip -y
    sudo apt install ansible -y
    ansible-galaxy collection install community.rabbitmq
    ssh-copy-id -i ~/.ssh/id_rsa rmq01 -f
    ssh-copy-id -i ~/.ssh/id_rsa rmq02 -f
    ssh-copy-id -i ~/.ssh/id_rsa rmq03 -f
fi
# ansible-galaxy collection install community.rabbitmq