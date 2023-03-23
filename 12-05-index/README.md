# Домашнее задание к занятию "`12.5. «Индексы»`" - `Александр Недорезов`

### Задание 1

Напишите запрос к учебной базе данных, который вернёт процентное отношение общего размера всех индексов к общему размеру всех таблиц.

> #### Ответ: 
> ```sql
> select
> 	concat(round(( (sum(t.INDEX_LENGTH)/ SUM(t.DATA_LENGTH)) * 100 ), 2), '%') > index_metric
> from
> 	INFORMATION_SCHEMA.tables t
> where
> 	t.TABLE_SCHEMA = 'sakila'
> ```
>  ![img](https://github.com/smutosey/sys-netology-hw/blob/main/12-05-index/img/1-01.png) 


### Задание 2

Выполните explain analyze следующего запроса:
```sql
select distinct concat(c.last_name, ' ', c.first_name), sum(p.amount) over (partition by c.customer_id, f.title)
from payment p, rental r, customer c, inventory i, film f
where date(p.payment_date) = '2005-07-30' and p.payment_date = r.rental_date and r.customer_id = c.customer_id and i.inventory_id = r.inventory_id
``` 
> Выборка заняла почти 7 секунд:
> ![img](https://github.com/smutosey/sys-netology-hw/blob/main/12-05-index/img/2-00.png) 

- перечислите узкие места; 
- оптимизируйте запрос: внесите корректировки по использованию операторов, при необходимости добавьте индексы.  

> #### Ответ: 
> Для начала, нужно понять, что выводит запрос. Это выборка за дату уникальных сумм платежей за аренду фильма, которые были внесены клиентами в день взятия в аренду.  
> Что важно, в запросе используется оконная функция при вычислении суммы платежей, которая группирует в разрере по "клиенту" `customer_id` и "фильму" `film_id`. Особенность оконных функций: количество строк в запросе не уменьшается по сравнении с исходной таблицей, отсюда следует, что она используется не случайно. Но группировка по `film_id` сейчас не даёт правильного результата, т.к. таблица `film` присоединена некорректно, "многое ко многим".  
> Таким образом, выделим узкие места запроса:  
> 1. Таблица `film` привязана как "многое ко многим" без условий. Нужно добавить в `where` условие `and f.film_id = i.film_id`, запрос будет работать значительно быстрее, но тогда и результат изменится, т.к. оконная функция отработает правильно.  
> 2. Если же изначально не было задумки группировать в разрезе фильмов уникальные суммы платежей, то нет смысла включать в запрос таблицы `film` и `inventory`, а следовательно и нет причин использоать оконную функцию, если можно ограничиться GROUP BY по `customer_id`. Тогда можно убрать и `distinct` дедупликацию
> 3. Связка таблиц `payment` и `rental` по дате. В таблице `rental` есть индекс `rental_date`, а вот в `payment` нет индекса по дате. Создадим с помощью ```CREATE UNIQUE INDEX payment_date_IDX USING BTREE ON sakila.payment (payment_date,rental_id);```. Хотя можно, наверное, и просто индекс на payment_date
> 4. Можно попробовать оптимизировать фильтр по дате. Сравнил различные EXPLAIN, конструкция `p.payment_date >= '2005-07-30' and p.payment_date < date_add('2005-07-30', interval 1 day)` отрабатывает быстрее, чем `between`, и еще быстрее, чем изначальное условие `date(p.payment_date) = '2005-07-30'`, т.к. оно бы преобразовывало datetimne в date
> 5. `JOIN ON` выглядит нагляднее и поприятнее, чем where + условия. Но на оптимальности запроса это не должно сказаться.  
> 
> Итого, я вижу два варианта, что хотел вывести изначальный автор запроса, а следовательно и два варианта оптимизации: 
> 1. Выборка за дату суммы платежей по клиентам, которые внесли оплату в день взятия в  аренду. Результат выборки совпадает с авторским.
> ```sql
> select
> 	concat(c.last_name, ' ', c.first_name),
> 	sum(p.amount)
> from
> 	sakila.payment p
> left join sakila.rental r ON
> 	r.rental_date = p.payment_date
> left join sakila.customer c ON
> 	c.customer_id = p.customer_id
> where
> 	p.payment_date >= '2005-07-30'
> 	and p.payment_date < date_add('2005-07-30', INTERVAL 1 DAY)
> group by
> 	p.customer_id
> ```
> Выборка за 3,5 мс:
> ![img](https://github.com/smutosey/sys-netology-hw/blob/main/12-05-index/img/2-01.png) 
> ![img](https://github.com/smutosey/sys-netology-hw/blob/main/12-05-index/img/2-02.png) 
> 
> 2. Выборка за дату сумм платежей за аренду фильма, которые были внесены клиентами в > день взятия в аренду, в разрезе клиентов и фильмов. Результат выборки не совпадает с > изначальным.
> ```sql
> select
> 	distinct concat(c.last_name, ' ', c.first_name),
> 	sum(p.amount) over (partition by c.customer_id,
> 	f.title)
> from
> 	sakila.payment p
> left join sakila.rental r ON
> 	r.rental_date = p.payment_date
> left join sakila.customer c ON
> 	c.customer_id = p.customer_id
> left join sakila.inventory i on
> 	i.inventory_id = r.inventory_id
> left join sakila.film f on
> 	f.film_id = i.film_id
> where
> 	p.payment_date >= '2005-07-30'
> 	and p.payment_date < date_add('2005-07-30', INTERVAL 1 DAY)
> ```
> Выборка за 6,7 мс:
> ![img](https://github.com/smutosey/sys-netology-hw/blob/main/12-05-index/img/2-03.png)  
> ![img](https://github.com/smutosey/sys-netology-hw/blob/main/12-05-index/img/2-04.png)   
> 

### Задание 3*

Самостоятельно изучите, какие типы индексов используются в PostgreSQL. Перечислите те индексы, которые используются в PostgreSQL, а в MySQL — нет.

*Приведите ответ в свободной форме.*

> #### Ответ: 
> Индексы, которые используются в PostgreSQL, а в MySQL — нет:
> 1. GiST-индексы (Generalized Search Tree) - это целая индексная инфраструктура, позволяет реализовать много разных стратегий индексирования. Основывается на построении древовидных структур, и используется для геометрических данных и полнотекстового поискаю.  
> 2. SP-GiST-индекс (space partitioned GiST) - GiST с пространственным разделением, SP-GiST позволяет организовывать на диске самые разные несбалансированные структуры данных, такие как деревья квадрантов, k-мерные и префиксные деревья. Полезны для несбалансированных данных, которые имеют естественный элемент кластеризации: ГИС, мультимедиа, IP-маршрутизация.  
> 3. BRIN-индекс (block range indexes) - хранит обобщённые сведения о значениях, находящихся в физически последовательно расположенных блоках таблицы. Более эффективный по величине и стоимости индекс, по сравнению с B-tree, используется для "биг дата".   
> 4. GIN-индекс (generalized inverted indexes) - особенно полезный индекс, когда множество значений хранится в одной колонке (json, array, hstore). Это «инвертированные индексы», в которых могут содержаться значения с несколькими ключами, например массивы. Инвертированный индекс содержит отдельный элемент для значения каждого компонента, и может эффективно работать в запросах, проверяющих присутствие определённых значений компонентов.  