# Домашнее задание к занятию "`11.4. RabbitMQ`" - `Александр Недорезов`

### Задание 1. Установка RabbitMQ

Используя Vagrant или VirtualBox, создайте виртуальную машину и установите RabbitMQ.
Добавьте management plug-in и зайдите в веб-интерфейс.

*Итогом выполнения домашнего задания будет приложенный скриншот веб-интерфейса RabbitMQ.*

> #### Ответ:
> Я решил начать сразу с 4 задания, поэтому написал [Vagrantfile](https://github.com/smutosey/sys-netology-hw/11-04-rabbitmq/vagrant/Vagrantfile) для создания ВМ контроллера и 3х нод кластера, написал [плейбук с ролями](https://github.com/smutosey/sys-netology-hw/11-04-rabbitmq/rabbitmq/playbook.yml), в [инвентори](https://github.com/smutosey/sys-netology-hw/11-04-rabbitmq/rabbitmq/hosts.yml) 1 мастер и 2 воркера
> 
> Статус нод в UI RabbitMQ:
> ![img](https://github.com/smutosey/sys-netology-hw/11-04-rabbitmq/img/1-01.png) 

---

### Задание 2. Отправка и получение сообщений

Используя приложенные скрипты, проведите тестовую отправку и получение сообщения.
Для отправки сообщений необходимо запустить скрипт producer.py.

Для работы скриптов вам необходимо установить Python версии 3 и библиотеку Pika.
Также в скриптах нужно указать IP-адрес машины, на которой запущен RabbitMQ, заменив localhost на нужный IP.

Зайдите в веб-интерфейс, найдите очередь под названием hello и сделайте скриншот.
После чего запустите второй скрипт consumer.py и сделайте скриншот результата выполнения скрипта

*В качестве решения домашнего задания приложите оба скриншота, сделанных на этапе выполнения. Для закрепления материала можете попробовать модифицировать скрипты, чтобы поменять название очереди и отправляемое сообщение.*



> #### Ответ:
> Немного [изменил](https://github.com/smutosey/sys-netology-hw/11-04-rabbitmq/scripts/) скрипты продюсера и консьюмера, очередь теперь "nedorezov", а также добавил credentials (чтобы логиниться не под guest), актуализировал вызов методов pika.   
> Результат работы продюсера:      
> ![img](https://github.com/smutosey/sys-netology-hw/11-04-rabbitmq/img/2-01.png)  
> 
> Результат запуска консьюмера:  
> ![img](https://github.com/smutosey/sys-netology-hw/11-04-rabbitmq/img/2-02.png)  
---

### Задание 3. Подготовка HA кластера

Используя Vagrant или VirtualBox, создайте вторую виртуальную машину и установите RabbitMQ.
Добавьте в файл hosts название и IP-адрес каждой машины, чтобы машины могли видеть друг друга по имени.

*В качестве решения домашнего задания приложите скриншоты из веб-интерфейса с информацией о доступных нодах в кластере и включённой политикой.*  

*Также приложите вывод команды `rabbitmqctl cluster_status` с двух нод*

*Для закрепления материала снова запустите скрипт producer.py и приложите скриншот выполнения команды `rabbitmqadmin get queue='hello'` на каждой из нод*

После чего попробуйте отключить одну из нод, желательно ту, к которой подключались из скрипта, затем поправьте параметры подключения в скрипте consumer.py на вторую ноду и запустите его.

*Приложите скриншот результата работы второго скрипта.*


> #### Ответ:
> Ноды в кластере всё те же:   
> ![img](https://github.com/smutosey/sys-netology-hw/11-04-rabbitmq/img/3-01.png)   
> Политики:  
> ![img](https://github.com/smutosey/sys-netology-hw/11-04-rabbitmq/img/3-02.png) 
> 
> Вывод команды `rabbitmqctl cluster_status` с двух нод:  
> ![img](https://github.com/smutosey/sys-netology-hw/11-04-rabbitmq/img/3-03.png) 
> 
> Вывод команды `rabbitmqadmin get queue='hello'` с двух нод:  
> ![img](https://github.com/smutosey/sys-netology-hw/11-04-rabbitmq/img/3-04.png)  
> 
> Проверим доступность кластера. Вырубил сервис на 1ой ноде, успешно поймал сообщения консьюмером:  
> ![img](https://github.com/smutosey/sys-netology-hw/11-04-rabbitmq/img/3-05.png)  
> ![img](https://github.com/smutosey/sys-netology-hw/11-04-rabbitmq/img/3-06.png) 


### Задание 4*. Ansible playbook

Напишите плейбук, который будет производить установку RabbitMQ на любое количество нод и объединять их в кластер.
При этом будет автоматически создавать политику ha-all.

*Готовый плейбук разместите в своём репозитории.*

> #### Ответ:  
> Все ноды для выполнения заданий 1-3 разворачивал написанным мною [плейбуком](https://github.com/smutosey/sys-netology-hw/11-04-rabbitmq/rabbitmq/playbook.yml).
В [инвентори](https://github.com/smutosey/sys-netology-hw/11-04-rabbitmq/rabbitmq/hosts.yml) для тест-окружения создал 1 мастер и 2 воркера. Плейбук адаптирован под ubuntu, протестирован на 20.04.  
> Настройка выполняется 2мя ролями:  
> - install_rabbitmq - выполняется на всех нодах. В тасках устанавливаются все необходимые пакеты, выполняются первичные настройки и обмен Erlang Cookie  
> - cluster_setup - выполняется на воркерах для подключения к мастер-ноде в кластер, а также настройка политик.  
>  
> Результат запуска плейбука:  
> ![img](https://github.com/smutosey/sys-netology-hw/11-04-rabbitmq/img/4-01.png)  
> ![img](https://github.com/smutosey/sys-netology-hw/11-04-rabbitmq/img/4-02.png) 
> Статус кластера:  
> ![img](https://github.com/smutosey/sys-netology-hw/11-04-rabbitmq/img/4-03.png) 