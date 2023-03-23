# Домашнее задание к занятию "`9.1. Обзор систем IT-мониторинга`" - `Александр Недорезов`

---

### Задание 1

Создайте виртуальную машину в Yandex Cloud Compute Cloud и с помощью Yandex Monitoring создайте дашборд, на котором будет видно загрузку процессора, количество занятой оперативной памяти и свободное место на жёстком диске.

### Ответ
1. Создал ВМ mon-vm, сервисный аккаунт с ролью "monitoring.admin" и  установленным агентом мониторинга YC
2. Собранный дашборд в YC для ВМ mon-vm:
![image](https://github.com/smutosey/sys-netology-hw/09-01-yc-mon/img/01.png)


---

### Задание 2*

С помощью Yandex Monitoring сделайте 2 алерта на загрузку процессора: WARN и ALARM. Создайте уведомление по e-mail.

### Ответ
1. Создал алерт на график CPU Usage:
![image](https://github.com/smutosey/sys-netology-hw/09-01-yc-mon/img/02-1.png)
с уведомлением на почту:
![image](https://github.com/smutosey/sys-netology-hw/09-01-yc-mon/img/02-2.png)
2. Провел стресс-тест CPU на ВМ mon-vm. На почту последовательно пришло два письма WARN и ALARM
![image](https://github.com/smutosey/sys-netology-hw/09-01-yc-mon/img/02-3.png)
![image](https://github.com/smutosey/sys-netology-hw/09-01-yc-mon/img/02-4.png)
3. График метрики и алерта:
![image](https://github.com/smutosey/sys-netology-hw/09-01-yc-mon/img/02-5.png)