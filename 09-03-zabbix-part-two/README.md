# Домашнее задание к занятию "`9.3. Система мониторинга Zabbix. Часть 2`" - `Александр Недорезов`

---

### Задание 1

Создайте свой шаблон, в котором будут элементы данных, мониторящие загрузку CPU и RAM хоста.

Сохраните в Git скриншот страницы шаблона с названием «Задание 1».

### Ответ

![image](https://github.com/smutosey/sys-netology-hw/blob/main/09-03-zabbix-part-two/img/01-1.png)

---

### Задание 2

Добавьте в Zabbix два хоста и задайте им имена <фамилия и инициалы-1> и <фамилия и инициалы-2>. Например: ivanovii-1 и ivanovii-2.

Результат этого задания сдавайте вместе с заданием 3.

---

### Задание 3

Привяжите созданный шаблон к двум хостам. Также привяжите к обоим хостам шаблон Linux by Zabbix Agent.

Сохраните в Git скриншот страницы хостов, где будут видны привязки шаблонов с названиями «Задание 2-3». Хосты должны иметь зелёный статус подключения.

### Ответ

![image](https://github.com/smutosey/sys-netology-hw/blob/main/09-03-zabbix-part-two/img/03-1.png)

---

### Задание 4

Создайте свой кастомный дашборд.

Сохраните в Git скриншот дашборда с названием «Задание 4».


### Ответ

![image](https://github.com/smutosey/sys-netology-hw/blob/main/09-03-zabbix-part-two/img/04-1.png)

---
---

### Задание 5*

Создайте карту и расположите на ней два своих хоста:
1. Настройте между хостами линк.
2. Привяжите к линку триггер, связанный с agent.ping одного из хостов, и установите индикатором сработавшего триггера красную пунктирную линию.
3. Выключите хост, чей триггер добавлен в линк. Дождитесь срабатывания триггера.

Сохраните в Git скриншот карты, где видно, что триггер сработал, с названием «Задание 5».*

### Ответ

Настроенный линк между хостами на карте:
![image](https://github.com/smutosey/sys-netology-hw/blob/main/09-03-zabbix-part-two/img/05-1.png)

Выключил на netology-as-2 сервис zabbix-agent:
![image](https://github.com/smutosey/sys-netology-hw/blob/main/09-03-zabbix-part-two/img/05-2.png)

Через 3 минуты на дашборде можно увидеть сработку триггера и порождённую проблему:
![image](https://github.com/smutosey/sys-netology-hw/blob/main/09-03-zabbix-part-two/img/05-3.png)

---

### Задание 6*

Создайте UserParameter на bash и прикрепите его к созданному вами ранее шаблону. Он должен вызывать скрипт, который:
1. при получении 1 будет возвращать ваши ФИО,
2. при получении 2 будет возвращать текущую дату.

Приложите в Git код скрипта, а также скриншот Latest data с результатом работы скрипта на bash, чтобы был виден результат работы скрипта при отправке в него 1 и 2.

### Ответ

Ссылка на скрипт: [bash script](https://github.com/smutosey/sys-netology-hw/blob/main/09-03-zabbix-part-two/task6_nedorezov.sh)

```bash
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
```

Настройка на агентах: 
![agents](https://github.com/smutosey/sys-netology-hw/blob/main/09-03-zabbix-part-two/img/06-1.png)

Результат в Latest Data: 
![latest data](https://github.com/smutosey/sys-netology-hw/blob/main/09-03-zabbix-part-two/img/06-2.png)

---

### Задание 7*

Доработайте Python-скрипт из лекции, создайте для него UserParameter и прикрепите его к созданному вами ранее шаблону. Скрипт должен:
1. при получении 1 возвращать ваши ФИО,
2. при получении 2 возвращать текущую дату,
3. делать всё, что делал скрипт из лекции.

Приложите код скрипта в Git. Приложите в Git скриншот Latest data с результатом работы скрипта на Python, чтобы были видны результаты работы скрипта при отправке в него 1, 2, -ping, а также -simple_print.

### Ответ

Ссылка на скрипт: [python script](https://github.com/smutosey/sys-netology-hw/blob/main/09-03-zabbix-part-two/task7_nedorezov.py)

```python
# только python 3.10+
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

```

Конфигурация агентов:
![agents](https://github.com/smutosey/sys-netology-hw/blob/main/09-03-zabbix-part-two/img/07-1.png)

Результат в Latest Data: 
![latest data](https://github.com/smutosey/sys-netology-hw/blob/main/09-03-zabbix-part-two/img/07-2.png)

---

### Задание 8*

Настройте автообнаружение и прикрепление к хостам созданного вами ранее шаблона.

Приложите в Git скриншот правила обнаружения. Приложите в Git скриншот страницы Discover, где видны оба хоста.

### Ответ

Настройка Discovery Actions:
![image](https://github.com/smutosey/sys-netology-hw/blob/main/09-03-zabbix-part-two/img/08-1.png)

Настройка Discovery Rules:
![image](https://github.com/smutosey/sys-netology-hw/blob/main/09-03-zabbix-part-two/img/08-3.png)

Обнаруженные хосты в Discovery:
![image](https://github.com/smutosey/sys-netology-hw/blob/main/09-03-zabbix-part-two/img/08-2.png)

---

### Задание 9*

Доработайте скрипты Vagrant для 2-х агентов, чтобы они были готовы к автообнаружению сервером, а также имели на борту разработанные вами ранее параметры пользователей.

Приложите в Git файлы Vagrantfile и zabbix-agent.sh.

### Ответ

Ссылки на файлы в репозитории:
1. [Vagrantfile](https://github.com/smutosey/sys-netology-hw/blob/main/09-03-zabbix-part-two/Vagrantfile). Изменения: 
* Скорректировал в virt_machines имя хостов и присваиваемый IP
* использование параметра ZABBIX_SERVER_IP в конфигурации, изменил сам IP сервера

2. [zabbix-agent.sh](https://github.com/smutosey/sys-netology-hw/blob/main/09-03-zabbix-part-two/zabbix-agent.sh). Изменения: 
* Добавление конфигурации в каталоге /etc/zabbix/zabbix_agentd.d/ - task6_nedorezov.conf  и task7_nedorezov.conf
* Создание скриптов для UserParameters в /etc/zabbix - task6_nedorezov.sh и task7_nedorezov.py