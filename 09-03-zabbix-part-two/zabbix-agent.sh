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

echo "*******************************************************************************"
echo "************************** INSTALLING ZABBIX-AGENT ****************************"
echo "*******************************************************************************"
wget https://repo.zabbix.com/zabbix/6.0/debian/pool/main/z/zabbix-release/zabbix-release_6.0-4%2Bdebian11_all.deb
dpkg -i zabbix-release_6.0-4+debian11_all.deb
apt update 
apt install zabbix-agent -y
sed -i "s/Server=127.0.0.1/Server=$6/g" /etc/zabbix/zabbix_agentd.conf
echo 'UserParameter=task6_nedorezov[*], bash /etc/zabbix/task6_nedorezov.sh $1' > /etc/zabbix/zabbix_agentd.d/task6_nedorezov.conf
echo 'UserParameter=task7_nedorezov[*], python3 /etc/zabbix/task7_nedorezov.py $1 $2' > /etc/zabbix/zabbix_agentd.d/task7_nedorezov.conf
systemctl restart zabbix-agent
systemctl enable zabbix-agent

if [[ ! -f /etc/zabbix/task6_nedorezov.sh ]]
then 
cat <<'EOF' > /etc/zabbix/task6_nedorezov.sh
#!/bin/bash
if [[ $1 -eq 1 ]]
then 
  echo "Nedorezov Aleksandr Sergeevich"
elif [[ $1 -eq 2 ]]
then
  date
else
  echo "ERROR: unknown params"
fi
EOF
fi

if [[ ! -f /etc/zabbix/task7_nedorezov.py ]]
then 
cat <<'EOF' > /etc/zabbix/task7_nedorezov.py
import sys
import os
import re
from datetime import datetime

def check(args):
    match args[1]:
        case '1': # Если 1
            # Выводим в консоль ФИО
            print('Nedorezov Aleksandr Sergeevich')
        case '2': # Если 2
            # Выводим в консоль текущую дату
            print(datetime.now())
        case '-ping': # Если -ping
            # Делаем пинг по заданному адресу
            result=os.popen("ping -c 1 " + args[2]).read()
            result=re.findall(r"time=(.*) ms", result)
            print(result[0])
        case '-simple_print': # Если simple_print
            # Выводим в консоль содержимое sys.arvg[2]
            print(args[2])
        case _: # Во всех остальных случаях
            # Выводим непонятый запрос в консоль.
            print(f"unknown input: {args[1]}")

check(sys.argv)
EOF
fi


echo "*******************************************************************************"
echo "********************************* END *****************************************"
echo "*******************************************************************************"