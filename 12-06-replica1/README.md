# Домашнее задание к занятию "`12.6. «Репликация и масштабирование. Часть 1»`" - `Александр Недорезов`

### Задание 1

На лекции рассматривались режимы репликации master-slave, master-master, опишите их различия.

*Ответить в свободной форме.*
> #### Ответ:
> * ***master-slave*** - В этом подходе выделяется один основной сервер базы данных, который называется Мастером. На нем происходят все изменения в данных (любые запросы  INSERT/UPDATE/DELETE). Slave-нода постоянно копирует все изменения с Мастера. С приложения на slave сервер отправляются запросы чтения данных (SELECT). Таким образом Мастер сервер отвечает за изменения данных, а Слейв за чтение.
>    
>   *Преимущества*:
>   * Чтение данных можно выполнять с любой ноды кластера, slave или master. Но выгоднее со Slave для распределения нагрузки.
>   * Резервные копии БД не влияют на master
>   * slave-ноды могут падать и лежать в downtime для проведения плановых работ без простоя сервиса в целом 
>   
>   *Недостатки*:
>   * в случае сбоя master необходимо вручную переводить slave-ноду в роль мастера, нет автоматического восстановления
>   * если мастер лежит, то это downtime сервиса и вероятная потеря данных
>   * запись и изменение данных только через master-ноду, т.е. нагрузку нельзя распределить балансировщиком
>   * каждая дополнительная slave-нода увеличивает нагрузку на master, т.к. часто происходит чтение журнала и копирование данных
>   
>   
> * ***master-master (или multi-master)*** - каждая нода кластера является мастером и слейвом одновременно. При данной репликации данные, попавшие на тот или иной сервер в кластере будут реплицированы между собой. В случае отказа одного из серверов другие ноды репликации прозрачно подхватят работу, т.е. не нужно вручную переводить Slave-ноду в Master (что вызовет простой сервиса). Фактически это просто настройка мастер-слэйв репликации много раз от одной ноды к другой по кругу (минимально - между двумя нодами). Круговая репликация (или circular replication) MySQL может быть использована для масштабирования MySQL нодов, доступных на запись (изменение базы данных).  
>    
>   *Преимущества*:
>   * Высокая отказоустойчивость
>   * Чтение данных с любой мастер-ноды (а они все master)
>   * Изменение и запись данных доступны на любую мастер-ноду кластера   
>   
>   *Недостатки*:
>   * Вероятна потеря консистентности данных. Могут возникнуть неразришимые конфликты при реплицировании, нет реализованного протокола, который отслеживает блокировки таблиц\баз между нодами. То есть, например, если мы используем внешние ключи (FOREIGN KEY) в нашей базе данных INSERT может завершится ошибкой, если ссылка на внешний ключ не успела реплицироваться.
>   * Чем больше узлов, тем сложнее восстановиться из-за причины выше. Выход из строя одного из серверов практически всегда приводит к потере каких-то данных. Последующее восстановление также сильно затрудняется необходимостью ручного анализа данных, которые успели либо не успели скопироваться.
>

---
---

### Задание 2

Выполните конфигурацию master-slave репликации, примером можно пользоваться из лекции.

*Приложите скриншоты конфигурации, выполнения работы: состояния и режимы работы серверов.*

> #### Ответ:
> Запустил master и slave через [docker-compose.yml](https://github.com/smutosey/sys-netology-hw/blob/main/12-06-replica1/master-slave/docker-compose.yml)  
> Сразу в контейнеры прокинул конфигурацию [master.cnf](https://github.com/smutosey/sys-netology-hw/blob/main/12-06-replica1/master-slave/master.cnf) и [slave.cnf](https://github.com/smutosey/sys-netology-hw/blob/main/12-06-replica1/master-slave/slave.cnf)   
> Настройку master и slave выполнял через [setup.sh](https://github.com/smutosey/sys-netology-hw/blob/main/12-06-replica1/master-slave/setup.sh)  
> ![img](https://github.com/smutosey/sys-netology-hw/blob/main/12-06-replica1/img/2-docker-status.png)
> Статус мастера:  
> ![img](https://github.com/smutosey/sys-netology-hw/blob/main/12-06-replica1/img/2-master-status.png)  
> Статус слейва:  
> ![img](https://github.com/smutosey/sys-netology-hw/blob/main/12-06-replica1/img/2-slave-status.png)  
> На мастере создал таблицу в БД:
> ![img](https://github.com/smutosey/sys-netology-hw/blob/main/12-06-replica1/img/2-create-table.png) 
> Подключился к slave, проверил, что таблица реплицировалась: 
> ![img](https://github.com/smutosey/sys-netology-hw/blob/main/12-06-replica1/img/2-table-on-slave.png) 
> Можно также проверить логи relay на слейве:
> ![img](https://github.com/smutosey/sys-netology-hw/blob/main/12-06-replica1/img/2-relay-log.png) 
> 

---
---

### Задание 3* 

Выполните конфигурацию master-master репликации. Произведите проверку.

*Приложите скриншоты конфигурации, выполнения работы: состояния и режимы работы серверов.*

> Запустил master-one и master-two через [docker-compose.yml](https://github.com/smutosey/sys-netology-hw/blob/main/12-06-replica1/master-master/docker-compose.yml)   
> Сразу в контейнеры прокинул конфигурацию [master-one.cnf](https://github.com/smutosey/sys-netology-hw/blob/main/12-06-replica1/master-master/master-one.cnf) и [master-two.cnf](https://github.com/smutosey/sys-netology-hw/blob/main/12-06-replica1/master-master/master-two.cnf)  
> Настройку master-one и master-two выполнял через [setup.sh](https://github.com/smutosey/sys-netology-hw/blob/main/12-06-replica1/master-master/setup.sh)  
> ![img](https://github.com/smutosey/sys-netology-hw/blob/main/12-06-replica1/img/3-01-status.png)  
> ![img](https://github.com/smutosey/sys-netology-hw/blob/main/12-06-replica1/img/3-02-status.png)  
> Проверку выполнял через [check.sh](https://github.com/smutosey/sys-netology-hw/blob/main/12-06-replica1/master-master/check.sh):  
>   * на master-one создаем таблицу  
>   * на master-two делаем insert в таблицу  
>   * на master-one селектим данные из таблицы  
> ![img](https://github.com/smutosey/sys-netology-hw/blob/main/12-06-replica1/img/3-check.png)  
> ![img](https://github.com/smutosey/sys-netology-hw/blob/main/12-06-replica1/img/3-check-another.png)  