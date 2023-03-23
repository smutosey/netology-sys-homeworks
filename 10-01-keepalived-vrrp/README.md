# Домашнее задание к занятию "`10.1. Keepalived/vrrp`" - `Александр Недорезов`



### Задание 1

Разверните топологию из лекции и выполните установку и настройку сервиса Keepalived.

*Пришлите скриншот рабочей конфигурации и состояния сервиса для каждого нода.*

### Ответ

Конфигурация node-1
![img](https://github.com/smutosey/sys-netology-hw/10-01-keepalived-vrrp/img/01-5.png)
![img](https://github.com/smutosey/sys-netology-hw/10-01-keepalived-vrrp/img/01-1.png)
![img](https://github.com/smutosey/sys-netology-hw/10-01-keepalived-vrrp/img/01-2.png)

Конфигурация node-2
![img](https://github.com/smutosey/sys-netology-hw/10-01-keepalived-vrrp/img/01-6.png)
![img](https://github.com/smutosey/sys-netology-hw/10-01-keepalived-vrrp/img/01-3.png)
![img](https://github.com/smutosey/sys-netology-hw/10-01-keepalived-vrrp/img/01-4.png)
Если уронить node-1, то в логах сервиса keepalived на node-2 видно переключение на MASTER, и в интерфейсе появляется виртуальный IP
![img](https://github.com/smutosey/sys-netology-hw/10-01-keepalived-vrrp/img/01-7.png)


---

### Задание 2*

Проведите тестирование работы ноды, когда один из интерфейсов выключен. Для этого:

* добавьте ещё одну виртуальную машину и включите её в сеть;
* на машине установите Wireshark и запустите процесс прослеживания интерфейса;
* запустите процесс ping на виртуальный хост;
* выключите интерфейс на одной ноде (мастер), остановите Wireshark;
* найдите пакеты ICMP, в которых будет отображён процесс изменения MAC-адреса одной ноды на другой.

*Пришлите скриншот до и после выключения интерфейса из Wireshark.*

### Ответ

До выключения интерфейса ответы приходят от MASTER-ноды:
![img](https://github.com/smutosey/sys-netology-hw/10-01-keepalived-vrrp/img/02-1.png)

После выключения интерфейса на node-1 видны broadcast-пакеты с информацией о новом mac для IP:
![img](https://github.com/smutosey/sys-netology-hw/10-01-keepalived-vrrp/img/02-2.png)

И затем по ping-запросам возвращается информация уже с BACKUP-ноды:
![img](https://github.com/smutosey/sys-netology-hw/10-01-keepalived-vrrp/img/02-3.png)

---

