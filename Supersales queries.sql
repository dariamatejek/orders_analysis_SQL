-- There is one main table in database called orders - this is the main fact table. The problem is that this table is separated in two: orders (all orders except those made in 2020)
-- and orders_2020 (all orders made in 2020). The best way to fix that would be to create one and only table for orders - meaning that we would store there all orders no matter what
-- year specific order was made. Let's start with that in below steps.

-- First, we need to create one table that will we have same columns as orders and orders_2020.
create table supersales.orders_total(
order_id int,
customer_id int,
order_date date,
shipping_date date,
shipping_mode varchar(200),
delivery_country varchar(200),
delivery_city varchar(200),
delivery_state varchar(200),
delivery_zip_code int,
order_return int)

-- Now, we can insert all data to new created table.
insert into supersales.orders_total(
order_id,
customer_id,
order_date,
shipping_date,
shipping_mode,
delivery_country,
delivery_city,
delivery_state,
delivery_zip_code,
order_return)
	select
		order_id,
		customer_id,
		order_date,
		shipping_date,
		shipping_mode,
		delivery_country,
		delivery_city,
		delivery_state,
		delivery_zip_code,
		order_return
	from
		supersales.orders
union
	select
		order_id,
		customer_id,
		order_date,
		shipping_date,
		shipping_mode,
		delivery_country,
		delivery_city,
		delivery_state,
		delivery_zip_code,
		order_return
	from
		supersales.orders_2020
		
-- Let's check how many rows we have in each table, so we can be sure that we didn't lost anything.
		
select COUNT(*) from supersales.orders_total

select COUNT(*) from supersales.orders

select COUNT(*) from supersales.orders_2020

-- In total there is now 5009 rows in table orders_total.
-- Now, let's explore the data.
-- We should make some aggregations to check how many orders have specific customer made, how many orders per order_rating there is, how many orders per product there is.
-- Those analysis let us check what we have in data and if there are some interesting informations which we can use to analyze and investigate.

-- Count total number of orders per customer and check which customer made most orders
select c.customer_name as customer, count(*) as total_number_of_orders from supersales.customers c 
left join supersales.orders_total o on o.customer_id = c.customer_id
group by c.customer_name 
order by total_number_of_orders desc
-- That has let us know that Emily Phan is a customer with most orders.
-- We can check in which years Emily Phan has made orders.

select YEAR(o.order_date) as order_year from supersales.orders_total o
join supersales.customers c on c.customer_id = o.customer_id
where customer_name = 'Emily Phan'
order by order_year asc
-- So the first year when order was made was 2001. The last one was made in 2029 (those are of course fake data in that database)

-- Let's check how many customers didn't make any order. To do that, we will again use group by formula
select customer_name, count(*) as total_number_of_orders from supersales.customers c 
left join supersales.orders_total o on o.customer_id = c.customer_id
group by customer_name 
having count(*) = 0
-- There is no customer in database with 0 orders, so everyone has made at least.

-- Let's check what products we have in our orders.
select * from supersales.products p 

select * from supersales.product_groups pg 
-- There is 17 product groups in our database divided by 3 categories: Furniture, Office Supplies, Technology.
-- Let's check how many products there is for category Furniture.
select count(*) as total_count_of_products from supersales.products p 
join supersales.product_groups pg on pg.group_id = p.group_id 
where category = 'Furniture'
-- There is 383 products in that category.

