-- Create a database for projects
CREATE DATABASE projects;

-- Create schema for Anita's Veg Café
CREATE SCHEMA anitas_veg_cafe;

-- Orders table (same as sales in original)
CREATE TABLE sales (
  "customer_id" VARCHAR(10),
  "order_date" DATE,
  "product_id" INTEGER
);

-- Insert orders data
INSERT INTO sales
  ("customer_id", "order_date", "product_id")
VALUES
  ('Aarav', '2021-01-01', 1),
  ('Aarav', '2021-01-01', 2),
  ('Aarav', '2021-01-07', 2),
  ('Aarav', '2021-01-10', 3),
  ('Aarav', '2021-01-11', 3),
  ('Aarav', '2021-01-11', 3),
  ('Meera', '2021-01-01', 2),
  ('Meera', '2021-01-02', 2),
  ('Meera', '2021-01-04', 1),
  ('Meera', '2021-01-11', 1),
  ('Meera', '2021-01-16', 3),
  ('Meera', '2021-02-01', 3),
  ('Rohan', '2021-01-01', 3),
  ('Rohan', '2021-01-01', 3),
  ('Rohan', '2021-01-07', 3);

-- Menu table
CREATE TABLE menu (
  "product_id" INTEGER,
  "product_name" VARCHAR(50),
  "price" INTEGER
);

-- Insert menu data
INSERT INTO menu
  ("product_id", "product_name", "price")
VALUES
  (1, 'Paneer Butter Masala', 180),
  (2, 'Veg Biryani', 150),
  (3, 'Masala Dosa', 120);

-- Members table (loyalty customers)
CREATE TABLE members (
  "customer_id" VARCHAR(10),
  "join_date" DATE
);

-- Insert members data
INSERT INTO members
  ("customer_id", "join_date")
VALUES
  ('Aarav', '2021-01-07'),
  ('Meera', '2021-01-09');

select * from sales;
select * from menu;
select * from members;


--Analytical Questions
--Help Anita answer the following questions using SQL:
--1. What is the total amount each customer has spent at the café?

select s.Customer_id,Sum(m.Price) as Total_spent
from sales s
inner join menu m using(Product_id)
group by Customer_id;


--2. How many distinct days has each customer placed an order?

select Customer_id,Count(Distinct Order_date) as Days
from sales
group by Customer_id;


---3. What was the first dish ordered by each customer?

select Customer_id,Product_name,order_date
from(select s.Customer_id,m.Product_name,s.order_date,DENSE_RANK() over(partition by s.Customer_id order by s.order_date) as rnk
	from sales s
	join menu m using(product_id)) as dish
where rnk = 1;

---4. Which menu item is the most popular overall?

select Product_name, Qty
from (select m.Product_name,Count(s.Product_id) as Qty
				from menu m 
				join sales s using(Product_id)
				group by Product_name)
order by Qty desc
limit 1
				
--5. What is the most frequently ordered dish for each customer?

select Customer_id,Product_name, Product_Qty,rnk
from(select Customer_id,Product_name, Product_Qty,
		DENSE_RANK() over(Partition by Customer_id ORDER BY Product_Qty Desc) as rnk
			from (select s.Customer_id,m.Product_name,Count(s.Product_id) as Product_Qty
				from menu m 
				join sales s using(Product_id)
				GROUP BY s.Customer_id, m.Product_name))			
where rnk = 1;



---6. After joining the loyalty program, what dish did each member first order?

select Customer_id,Product_name,join_date,order_date,order_series
from(select mm.Customer_id,m.Product_name,s.order_date,mm.join_date,DENSE_RANK() over(partition by mm.Customer_id order by s.order_date) as order_series
	from sales s
	join menu m using(Product_id)
	join members mm using(customer_id)
	where s.order_date >= mm.join_date)
where order_series = 1;

---7. Before joining the loyalty program, what dish did each customer order last?

select Customer_id,Product_name,join_date,order_date,order_series
from(select mm.Customer_id,m.Product_name,s.order_date,mm.join_date,DENSE_RANK() over(partition by mm.Customer_id order by s.order_date desc) as order_series
	from sales s
	join menu m using(Product_id)
	join members mm using(customer_id)
	where s.order_date < mm.join_date)
where order_series = 1;


--8. For each member, how many items and how much did they spend before joining?

select mm.Customer_id,Count(s.product_id) as Total_items,sum(m.price) as Total_spend	
	from sales s
	join menu m using(Product_id)
	join members mm using(customer_id)
	where s.order_date < mm.join_date
	group by mm.Customer_id

--9. If each ₹1 = 10 points, and Paneer Butter Masala earns double points, how many points does each customer earn?

select s.Customer_id,sum(case
							when  m.product_name = 'Paneer Butter Masala' then 2*(10*m.price)
							else 10*m.price
						END) as Points
	from sales s
	join menu m using(Product_id)
	group by s.Customer_id;

--10. In their first loyalty week (starting from join_date), members earn double points on all items. 
--How many points do Aarav and Meera have by the end of January?

select s.Customer_id, sum(case
						when s.order_date between mm.join_date and mm.join_date + INTERVAL '6 days' 
							then 2*10*m.price
						else 10*m.price
						end) as points
from sales s
join menu m using(product_id)
join members mm using(customer_id)
WHERE s.order_date <= '2026-01-31'   AND s.Customer_id IN ('Aarav', 'Meera')
group by s.Customer_id;






  