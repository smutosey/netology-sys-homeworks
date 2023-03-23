# Домашнее задание к занятию "`12.3. «SQL. Часть 1»`" - `Александр Недорезов`

Задание можно выполнить как в любом IDE, так и в командной строке.

### Задание 1

Получите уникальные названия районов из таблицы с адресами, которые начинаются на “K” и заканчиваются на “a” и не содержат пробелов.

> #### Ответ: 
> ```sql
> select 
>   distinct addr.district 
> from 
>   sakila.address addr 
> where 
>   addr.district like 'K%a' 
>   and position(' ' in addr.district) = 0
> 
> ```  
> ![img](https://github.com/smutosey/sys-netology-hw/blob/main/12-03-sql1/img/1-01.png)  

### Задание 2

Получите из таблицы платежей за прокат фильмов информацию по платежам, которые выполнялись в промежуток с 15 июня 2005 года по 18 июня 2005 года **включительно** и стоимость которых превышает 10.00.

> #### Ответ: 
> ```sql
> select
> 	*
> from
> 	sakila.payment pay
> where
> 	pay.payment_date between "2005-06-15 00:00:00" and "2005-06-18 23:59:59"
> 	and pay.amount > 10
> ```  
> ![img](https://github.com/smutosey/sys-netology-hw/blob/main/12-03-sql1/img/2-01.png) 


### Задание 3

Получите последние пять аренд фильмов.

> #### Ответ: 
> ```sql
> select
> 	rent.*,
> 	f.title
> from
> 	sakila.rental rent
> join sakila.inventory i on
> 	i.inventory_id = rent.inventory_id
> join sakila.film f on
> 	f.film_id = i.film_id
> order by
> 	rent.rental_date desc
> limit 5
> ```  
> ![img](https://github.com/smutosey/sys-netology-hw/blob/main/12-03-sql1/img/3-01.png) 

### Задание 4

Одним запросом получите активных покупателей, имена которых Kelly или Willie. 

Сформируйте вывод в результат таким образом:
- все буквы в фамилии и имени из верхнего регистра переведите в нижний регистр,
- замените буквы 'll' в именах на 'pp'.

> #### Ответ: 
> ```sql
> select
> 	c.customer_id,
> 	REPLACE(lower(c.first_name), 'll', 'pp') as weird_first_name,
> 	REPLACE(lower(c.last_name), 'll', 'pp') as weird_last_name,
> 	c.active,
> 	c.email,
> 	c.create_date
> from
> 	sakila.customer c
> where
> 	lower(c.first_name) in ('kelly', 'willie')
> 	and c.active
> ```  
> ![img](https://github.com/smutosey/sys-netology-hw/blob/main/12-03-sql1/img/4-01.png) 

### Задание 5*

Выведите Email каждого покупателя, разделив значение Email на две отдельных колонки: в первой колонке должно быть значение, указанное до @, во второй — значение, указанное после @.

> #### Ответ: 
> ```sql
> select
> 	SUBSTRING_INDEX(c.email, '@', 1) as "left",
> 	SUBSTRING_INDEX(c.email, '@', -1) as "right"
> from
> 	sakila.customer c;
> ```  
> ![img](https://github.com/smutosey/sys-netology-hw/blob/main/12-03-sql1/img/5-01.png) 


### Задание 6*

Доработайте запрос из предыдущего задания, скорректируйте значения в новых колонках: первая буква должна быть заглавной, остальные — строчными.

> #### Ответ: 
> ```sql
> select
> 	CONCAT(
> 		LEFT(UPPER(SUBSTRING_INDEX(c.email, '@', 1)), 1), 
> 		SUBSTRING(LOWER(SUBSTRING_INDEX(c.email, '@', 1)), 2)
> 	) as "left",
> 	CONCAT(
> 		LEFT(UPPER(SUBSTRING_INDEX(c.email, '@', -1)), 1), 
> 		SUBSTRING(LOWER(SUBSTRING_INDEX(c.email, '@', -1)), 2)
> 	) as "right"
> from
> 	sakila.customer c;
> ```  
> ![img](https://github.com/smutosey/sys-netology-hw/blob/main/12-03-sql1/img/6-01.png) 