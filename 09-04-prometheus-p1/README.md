# Домашнее задание к занятию "`9.4. Prometheus`" - `Александр Недорезов`

---

Для выполнения заданий 1-4 написал [Vagrantfile](https://github.com/smutosey/sys-netology-hw/blob/main/09-04-prometheus-p1/Vagrantfile) 
и файл provision [config.sh](https://github.com/smutosey/sys-netology-hw/blob/main/09-04-prometheus-p1/config.sh)

---


### Задание 1

Установите Prometheus.

Приведите скриншот systemctl status prometheus, где будет написано: prometheus.service — Prometheus Service Netology Lesson 9.4 — [Ваши ФИО].

### Ответ

![img](https://github.com/smutosey/sys-netology-hw/blob/main/09-04-prometheus-p1/img/01-1.png)

---

### Задание 2

Установите Node Exporter.

Приведите скриншот systemctl status node-exporter, где будет написано: node-exporter.service — Node Exporter Netology Lesson 9.4 — [Ваши ФИО].

### Ответ

![img](https://github.com/smutosey/sys-netology-hw/blob/main/09-04-prometheus-p1/img/02-1.png)

---

### Задание 3

Подключите Node Exporter к серверу Prometheus.

Приложите скриншот конфига из интерфейса Prometheus вкладки Status > Configuration. Приложите скриншот из интерфейса Prometheus вкладки Status > Targets, чтобы было видно минимум два эндпоинта.

### Ответ

Status > Configuration:
![img](https://github.com/smutosey/sys-netology-hw/blob/main/09-04-prometheus-p1/img/03-1.png)

Status > Targets
![img](https://github.com/smutosey/sys-netology-hw/blob/main/09-04-prometheus-p1/img/03-2.png)

---

### Задание 4*

Установите Grafana.

Приложите скриншот левого нижнего угла интерфейса, чтобы при наведении на иконку пользователя были видны ваши ФИО.

### Ответ

![image](https://github.com/smutosey/sys-netology-hw/blob/main/09-04-prometheus-p1/img/04-1.png)


---

### Задание 5*

Интегрируйте Grafana и Prometheus.

Приложите скриншот дашборда (ID:1860) с поступающими туда данными из Node Exporter.

### Ответ

![image](https://github.com/smutosey/sys-netology-hw/blob/main/09-04-prometheus-p1/img/05-1.png)