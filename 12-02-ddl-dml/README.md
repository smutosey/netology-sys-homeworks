# Домашнее задание к занятию "`12.2. Работа с данными (DDL/DML)`" - `Александр Недорезов`

Задание можно выполнить как в любом IDE, так и в командной строке.

### Задание 1
1.1. Поднимите чистый инстанс MySQL версии 8.0+. Можно использовать локальный сервер или контейнер Docker.  
> [Vagrantfile](https://github.com/smutosey/sys-netology-hw/12-02-ddl-dml/vagrant/Vagrantfile) + [config.sh](https://github.com/smutosey/sys-netology-hw/12-02-ddl-dml/vagrant/config.sh) для создания ВМ, установки Docker и запуска MySQL в контейнере  
> [docker-compose.yml](https://github.com/smutosey/sys-netology-hw/12-02-ddl-dml/docker-compose.yml) - инструкции для запуска MySQL и инициализации БД   

1.2. Создайте учётную запись sys_temp. 
> ```sql
> CREATE USER 'sys_temp'@'%' IDENTIFIED BY 'password';
> ```  

1.3. Выполните запрос на получение списка пользователей в базе данных. (скриншот)
> ```sql
> select * from mysql.user;
> ```  
> ![img](https://github.com/smutosey/sys-netology-hw/12-02-ddl-dml/img/1-03.png)  

1.4. Дайте все права для пользователя sys_temp.   
> ```sql
> grant all privileges on *.* to 'sys_temp'@'%';
> ``` 

1.5. Выполните запрос на получение списка прав для пользователя sys_temp. (скриншот)  
> ```sql
> show grants for 'sys_temp'@'%';
> ``` 
> ![img](https://github.com/smutosey/sys-netology-hw/12-02-ddl-dml/img/1-05.png)  

1.6. Переподключитесь к базе данных от имени sys_temp.  
> ![img](https://github.com/smutosey/sys-netology-hw/12-02-ddl-dml/img/1-06.png)  

1.7. По ссылке https://downloads.mysql.com/docs/sakila-db.zip скачайте дамп базы данных.  

1.8. Восстановите дамп в базу данных.
> ![img](https://github.com/smutosey/sys-netology-hw/12-02-ddl-dml/img/1-08.png)  

1.9. При работе в IDE сформируйте ER-диаграмму получившейся базы данных. При работе в командной строке используйте команду для получения всех таблиц базы данных. (скриншот)  
> ![img](https://github.com/smutosey/sys-netology-hw/12-02-ddl-dml/img/1-09.png)  
> ![img](https://github.com/smutosey/sys-netology-hw/12-02-ddl-dml/img/1-09-2.png)  


*Результатом работы должны быть скриншоты обозначенных заданий, а также простыня со всеми запросами.*


### Задание 2
Составьте таблицу, используя любой текстовый редактор или Excel, в которой должно быть два столбца: в первом должны быть названия таблиц восстановленной базы, во втором названия первичных ключей этих таблиц. Пример: (скриншот/текст)
```
Название таблицы | Название первичного ключа
customer         | customer_id
```
> #### Ответ
> Сделал это скриптом SQL:  
> ```sql
> select
> 	tables.table_name as "Название таблицы",
> 	stats.column_name as "Название первичного ключа"
> from
> 	information_schema.tables as tables
> join information_schema.statistics as stats
>         on
> 	stats.table_schema = tables.table_schema
> 	and stats.table_name = tables.table_name
> 	and stats.index_name = 'primary'
> where
> 	tables.table_schema = 'sakila'
> 	and tables.table_type = 'BASE TABLE'
> order by
> 	tables.table_name
> ```   
> 
> Скриншот:  
> ![img](https://github.com/smutosey/sys-netology-hw/12-02-ddl-dml/img/2-01.png) 
>   
> Полученная таблица, выгруженная из IDE DBeaver: [туть](https://github.com/smutosey/sys-netology-hw/12-02-databases/nedorezov_202303121953-1678625633403.csv) 




## Дополнительные задания (со звёздочкой*)
Эти задания дополнительные, то есть не обязательные к выполнению, и никак не повлияют на получение вами зачёта по этому домашнему заданию. Вы можете их выполнить, если хотите глубже шире разобраться в материале.

### Задание 3*
3.1. Уберите у пользователя sys_temp права на внесение, изменение и удаление данных из базы sakila.

3.2. Выполните запрос на получение списка прав для пользователя sys_temp. (скриншот)

*Результатом работы должны быть скриншоты обозначенных заданий, а также простыня со всеми запросами.*

> В MySQL DCL отсутствует оператор DENY, и т.к. ранее выдавали ему полный доступ (а так делать нельзя), то отзываем доступ и выдаем точечно к базам данных. Судя по условиям, это админская учетка с полным системным доступом, но не имеющая доступ на изменение таблицы sakila, поэтому::
> ```sql
> revoke all privileges on *.* from 'sys_temp'@'%';  --отзываем полный доступ
> grant all privileges on sys.* to 'sys_temp'@'%'; --полный доступ к БД sys
> grant all privileges on sakila.* to 'sys_temp'@'%'; --полный доступ к БД sakila  (пока что)
> revoke INSERT, UPDATE, DELETE on sakila.* from 'sys_temp'@'%' --отзываем доступ к внесению, изменению и удалению данных в БД sakila
> ``` 
> Результат выполнения и список прав:
> ![img](https://github.com/smutosey/sys-netology-hw/12-02-ddl-dml/img/3-01.png)  
> Видно, что нет доступа на INSERT, UPDATE, DELETE в sakila 