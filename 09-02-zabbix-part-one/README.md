# Домашнее задание к занятию "`9.2. Zabbix. Часть 1`" - `Александр Недорезов`

---

### Задание 1

Установите Zabbix Server с веб-интерфейсом.
Приложите скриншот авторизации в админке. Приложите текст использованных команд в GitHub.

### Ответ

1. Установил PostgreSQL
```
sudo apt install postgresql
```
2. Установил репозиторий Zabbix
```
wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-4%2Bubuntu22.04_all.deb
sudo dpkg -i zabbix-release_6.0-4+ubuntu22.04_all.deb
sudo apt update
```
3. Установка Zabbix Server с фронтом:
```
apt install zabbix-server-pgsql zabbix-frontend-php php8.1-pgsql zabbix-nginx-conf zabbix-sql-scripts zabbix-agent
```
4. Создание роли и БД в PostgreSQ
```
su - postgres -c 'psql --command "CREATE USER zabbix WITH PASSWORD '\'123456789\'';"'
su - postgres -c 'psql --command "CREATE DATABASE zabbix OWNER zabbix;"'
```
5. Импорт схемы в БД: 
```
zcat /usr/share/zabbix-sql-scripts/postgresql/server.sql.gz | sudo -u zabbix psql zabbix
```
6. Конфигурация Zabbix Server
```
sed -i 's/# DBPassword=/DBPassword=123456789/g' /etc/zabbix/zabbix_server.conf
```
7. Конфигурация NGINX
```
sed -i 's/# listen/listen/g' /etc/zabbix/nginx.conf
sed -i 's/# server_name/server_name/g' /etc/zabbix/nginx.conf
```
8. Перезапуск процессов и добавление в загрузку systemd
```
systemctl restart zabbix-server zabbix-agent nginx php8.1-fpm
systemctl enable zabbix-server zabbix-agent nginx php8.1-fpm
```
9. Успешная установка:
![image](https://github.com/smutosey/sys-netology-hw/09-02-zabbix-part-one/img/01-1.png)
10. Авторизация в админке:
![image](https://github.com/smutosey/sys-netology-hw/09-02-zabbix-part-one/img/01-2.png)

---

### Задание 2

Установите Zabbix Agent на два хоста.
Приложите скриншот раздела Configuration > Hosts, где видно, что агенты подключены к серверу. Приложите скриншот лога zabbix agent, где видно, что он работает с сервером. Приложите скриншот раздела Monitoring > Latest data для обоих хостов, где видны поступающие от агентов данные. Приложите текст использованных команд в GitHub.

### Ответ

1. Установка репозитория
```
wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-4%2Bubuntu22.04_all.deb
dpkg -i zabbix-release_6.0-4+ubuntu22.04_all.deb
apt update
```
2. Установка Zabbix-агента
```
apt install zabbix-agent
```
3. Конфигурация агента
```
sed -i 's/Server=127.0.0.1/Server=192.168.0.106/g' /etc/zabbix/zabbix_agentd.conf
```
включаем дебаг, чтобы видеть запросы от сервера:
```
sed -i 's/# DebugLevel=3/DebugLevel=4/g' /etc/zabbix/zabbix_agentd.conf
```
4. Рестарт сервиса и добавление в загрузку systemd
```
systemctl restart zabbix-agent
systemctl enable zabbix-agent
```
5. Скриншот раздела Configuration > Hosts на сервере:
![image](https://github.com/smutosey/sys-netology-hw/09-02-zabbix-part-one/img/02-1.png)
6. Скриншот лога zabbix agent с дебагом соединения:
![image](https://github.com/smutosey/sys-netology-hw/09-02-zabbix-part-one/img/02-2.png)
7. Скриншот раздела Monitoring > Latest data для обоих хостов, видны поступающие от агентов данные
![image](https://github.com/smutosey/sys-netology-hw/09-02-zabbix-part-one/img/02-3.png)
8. Пример сконфигурированного дашборда
![image](https://github.com/smutosey/sys-netology-hw/09-02-zabbix-part-one/img/02-4.png)



---

### Задание 3*

Установите Zabbix Agent на Windows (компьютер) и подключите его к серверу Zabbix.
Приложите скриншот раздела Latest Data, где видно свободное место на диске C:

### Ответ

1. Установка Zabbix-агента на windows происходит через .msi-пакет, скачанный с сайта.
2. При инсталляции указывается адрес ```Zabbix Server = 192.168.0.106```
3. На сервере добавил хост Windows, с шаблоном ```Windows filesystems by Zabbix agent```
![image](https://github.com/smutosey/sys-netology-hw/09-02-zabbix-part-one/img/03-1.png)
4. В шаблоне есть discovery rule "Mounted filesystem discovery", и по нему Items создаются только Space utilization, Total space и Used space, поэтому, чтобы видеть именно свободное место дисков, решил добавить в этот же шаблон новый item Free Space с ключом ```vfs.fs.size[{#FSNAME},pfree]```
5. Полученные данные в Latest Data:
![image](https://github.com/smutosey/sys-netology-hw/09-02-zabbix-part-one/img/03-2.png)

