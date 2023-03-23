# Домашнее задание к занятию "`12.4. «SQL. Часть 2»`" - `Александр Недорезов`

### Задание 1

Одним запросом получите информацию о магазине, в котором обслуживается более 300 покупателей, и выведите в результат следующую информацию: 
- фамилия и имя сотрудника из этого магазина;
- город нахождения магазина;
- количество пользователей, закреплённых в этом магазине.

> #### Ответ: 
>
> Вариант 1. Оптимальный
> ```sql
> SELECT
> 	staff.first_name,
> 	staff.last_name,
> 	city.city,
> 	customers.cnt
> FROM 
> 	sakila.store AS store
> RIGHT JOIN (
> 	SELECT
> 		store_id,
> 		count(*) as cnt
> 	from
> 		sakila.customer
> 	group by
> 		store_id
> 	having
> 		count(*) > 300) as customers on
> 	customers.store_id = store.store_id
> JOIN sakila.staff AS staff ON
> 	store.manager_staff_id = staff.staff_id
> JOIN sakila.address AS addr ON
> 	store.address_id = addr.address_id
> JOIN sakila.city city ON
> 	addr.city_id = city.city_id
> ```
> ![img](https://github.com/smutosey/sys-netology-hw/blob/main/12-04-sql2/img/1-02.png)  
>
> Вариант 2. Некрасивый, но дешевле по плану запроса
> ```sql
> select
> 	stf.first_name "Manager first name", 
> 	stf.last_name "Manager last name",
> 	city.city "Store's city",
> 	(
> 	select
> 		count(1)
> 	from
> 		sakila.customer cs
> 	where
> 		cs.store_id = s.store_id ) "Customers count"
> from
> 	sakila.store s
> join sakila.staff stf on
> 	s.manager_staff_id = stf.staff_id
> join sakila.address a on
> 	s.address_id = a.address_id
> join sakila.city city on
> 	a.city_id = city.city_id
> where
> 	exists (
> 	select
> 		c.store_id,
> 		count(1)
> 	from
> 		sakila.customer c
> 	where
> 		c.store_id = s.store_id
> 	group by
> 		c.store_id
> 	having
> 		count(1) > 300)
> ```  
> ![img](https://github.com/smutosey/sys-netology-hw/blob/main/12-04-sql2/img/1-03.png)  


### Задание 2

Получите количество фильмов, продолжительность которых больше средней продолжительности всех фильмов.

> #### Ответ: 
> ```sql
> select
> 	count(1)
> from
> 	sakila.film f
> where
> 	f.length > (
> 	select
> 		AVG(f.length)
> 	from
> 		sakila.film f )
> ```  
> ![img](https://github.com/smutosey/sys-netology-hw/blob/main/12-04-sql2/img/2-01.png)  


### Задание 3

Получите информацию, за какой месяц была получена наибольшая сумма платежей, и добавьте информацию по количеству аренд за этот месяц.  

> #### Ответ:  
> Группировать просто по MONTH() не получится, т.к. при выборке за несколько лет получим искаженные данные. Поэтому:
> ```sql
> select
> 	date_format(p.payment_date,'%Y-%m') month, count(*) payment_cnt
> from
> 	sakila.payment p 
> group by date_format(p.payment_date,'%Y-%m')
> order by count(*) desc
> LIMIT 1
> ```  
> ![img](https://github.com/smutosey/sys-netology-hw/blob/main/12-04-sql2/img/3-01.png)  


### Задание 4*

Посчитайте количество продаж, выполненных каждым продавцом. Добавьте вычисляемую колонку «Премия». Если количество продаж превышает 8000, то значение в колонке будет «Да», иначе должно быть значение «Нет».

> #### Ответ:  
> ```sql
> select
> 	s.staff_id "ID",
> 	CONCAT(s.first_name, ' ', s.last_name) "Сотрудник",
> 	p.cnt "Количество продаж",
> 	case
> 		when p.cnt > 8000 then 'Да'
> 		else 'Нет'
> 	end as "Премия"
> from
> 	sakila.staff s
> left join (
> 	select
> 		p.staff_id,
> 		count(1) cnt
> 	from
> 		sakila.payment p
> 	group by
> 		p.staff_id) p on
> 	p.staff_id = s.staff_id
> ```  
> ![img](https://github.com/smutosey/sys-netology-hw/blob/main/12-04-sql2/img/4-01.png) 
> 
> Но, как будто бы такая система премирования не совсем правильная :) Введем месячную премию с учетом суммы продаж:  
> ```sql
> select
> 	s.staff_id "ID",
> 	CONCAT(s.first_name, ' ', s.last_name) "Сотрудник",
> 	p.month "Месяц", 
> 	p.payment_sum "Сумма продаж",
> 	p.cnt "Количество продаж",
> 	case
> 		when p.payment_sum > 8000 then 'Да'
> 		else 'Нет'
> 	end as "Премия"
> from
> 	sakila.staff s
> left join (
> 	select
> 		p.staff_id,
> 		date_format(p.payment_date, '%Y-%m') as month,
> 		sum(p.amount) as payment_sum,
> 		count(1) cnt
> 	from
> 		sakila.payment p
> 	group by
> 		p.staff_id,
> 		date_format(p.payment_date, '%Y-%m')) p on
> 	p.staff_id = s.staff_id
> ``` 
> ![img](https://github.com/smutosey/sys-netology-hw/blob/main/12-04-sql2/img/4-02.png) 

### Задание 5*

Найдите фильмы, которые ни разу не брали в аренду.

> #### Ответ:  
> ```sql
> select
> 	f.film_id, f.title
> from
> 	sakila.film f
> where
> 	f.film_id not in (
> 	select
> 		i.film_id
> 	from
> 		sakila.rental r
> 	left join sakila.inventory i on
> 		i.inventory_id = r.inventory_id)
> ```  
> ![img](https://github.com/smutosey/sys-netology-hw/blob/main/12-04-sql2/img/5-01.png) 