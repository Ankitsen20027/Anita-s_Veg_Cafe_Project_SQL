# Anita's Veg Café — SQL Data Analysis Project

## Overview
This project analyzes sales, menu, and loyalty program data for **Anita's Veg Café**, a small vegetarian café in Bengaluru. As Anita's data consultant, the goal is to answer key business questions about customer spending, dish popularity, and loyalty program impact using SQL — practicing joins, aggregations, window functions, CASE statements, and date logic.

## Business Context
Anita opened her café in early 2021, serving a small but popular vegetarian menu:
- Paneer Butter Masala
- Veg Biryani
- Masala Dosa

After a few weeks, she introduced a loyalty program to reward repeat customers. This project digs into the data to understand which dishes are most loved, how loyalty membership shapes customer behavior, and what strategies could help the business grow.

## Dataset

The data lives under the schema `anitas_veg_cafe` and consists of three tables:

| Table | Description | Columns |
|---|---|---|
| `sales` | Every item ordered, by customer and date | `customer_id`, `order_date`, `product_id` |
| `menu` | Menu items and pricing | `product_id`, `product_name`, `price` |
| `members` | Customers enrolled in the loyalty program | `customer_id`, `join_date` |

### Entity Relationship Diagram
`sales.customer_id` → `members.customer_id`
`sales.product_id` → `menu.product_id`

## Analytical Questions Answered

1. What is the total amount each customer has spent at the café?
2. How many distinct days has each customer placed an order?
3. What was the first dish ordered by each customer?
4. Which menu item is the most popular overall?
5. What is the most frequently ordered dish for each customer?
6. After joining the loyalty program, what dish did each member first order?
7. Before joining the loyalty program, what dish did each customer order last?
8. For each member, how many items and how much did they spend before joining?
9. If each ₹1 = 10 points, and Paneer Butter Masala earns double points, how many points does each customer earn?
10. In their first loyalty week (starting from `join_date`), members earn double points on all items. How many points do Aarav and Meera have by the end of January?

## Skills Demonstrated

- **Joins** — combining `sales`, `menu`, and `members` to enrich transaction-level data
- **Aggregations** — `SUM`, `COUNT` for spend and order frequency
- **Window functions** — `DENSE_RANK() OVER (PARTITION BY ...)` to find first/last/most-frequent orders per customer
- **CASE statements** — conditional loyalty points logic
- **Date logic** — filtering and comparing orders relative to loyalty `join_date`, including a rolling 7-day bonus window

## How to Run

1. Create the database and schema:
   ```sql
   CREATE DATABASE projects;
   CREATE SCHEMA anitas_veg_cafe;
   ```
2. Run the table creation and `INSERT` statements in [`anitas_cafe_analysis.sql`](./anitas_cafe_analysis.sql) to load the sample data.
3. Run each numbered query to see the answer to the corresponding business question.

## Tech Stack
- PostgreSQL (uses `INTERVAL`, `DENSE_RANK()`, and `USING` join syntax)

## Author
Ankit Sen
