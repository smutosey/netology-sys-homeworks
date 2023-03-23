# Домашнее задание к занятию "`9.5. Prometheus Ч.2`" - `Александр Недорезов`

---

### Задание 1


Создайте файл с правилом оповещения, как в лекции, и добавьте его в конфиг Prometheus.

*Погасите node exporter, стоящий на мониторинге, и прикрепите скриншот раздела оповещений Prometheus, где оповещение будет в статусе Pending.*

### Ответ

![img](https://github.com/smutosey/sys-netology-hw/blob/main/09-05-prometheus-p2/img/01-1.png)

---

### Задание 2

Установите Alertmanager и интегрируйте его с Prometheus.

*Прикрепите скриншот Alerts из Prometheus, где правило оповещения будет в статусе Fireing, и скриншот из Alertmanager, где будет видно действующее правило оповещения.*

### Ответ

Alerts из Prometheus в статусе Fireing:
![img](https://github.com/smutosey/sys-netology-hw/blob/main/09-05-prometheus-p2/img/02-1.png)

Оповещение в Alertmanager:
![img](https://github.com/smutosey/sys-netology-hw/blob/main/09-05-prometheus-p2/img/02-2.png)

---

### Задание 3

Активируйте экспортёр метрик в Docker и подключите его к Prometheus.

*Приложите скриншот браузера с открытым эндпоинтом, а также скриншот списка таргетов из интерфейса Prometheus.*

### Ответ

Эндпоинт с метриками Docker: 
![img](https://github.com/smutosey/sys-netology-hw/blob/main/09-05-prometheus-p2/img/03-1.png)

Список таргетов в Prometheus: 
![img](https://github.com/smutosey/sys-netology-hw/blob/main/09-05-prometheus-p2/img/03-2.png)

---

### Задание 4*

Создайте свой дашборд Grafana с различными метриками Docker и сервера, на котором он стоит.

*Приложите скриншот, на котором будет дашборд Grafana с действующей метрикой.*

### Ответ

Кастомный дашборд:
![img](https://github.com/smutosey/sys-netology-hw/blob/main/09-05-prometheus-p2/img/04-1.png)
