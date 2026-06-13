create database sales_db;

use sales_db;

select transactions_id from sales;

select * from sales;

-- Changing the ï»¿transactions_id column to transactions_id.
ALTER TABLE sales
RENAME COLUMN ï»¿transactions_id TO transactions_id;

-- Checking the number of rows in the .
select count(*) from sales;

-- Checking the schema of the table.
desc sales;

-- Converting the sale_date and sale_time columns from text to date type.
alter table sales
add column sales_date date;
SET SQL_SAFE_UPDATES = 0;

update sales
set sales_date = str_to_date(sale_date,'%d-%m-%Y');

alter table sales
add column sales_time time;
-- Deleting the previous columns
alter table sales
drop column sale_date,
drop column sale_time;
update sales
set sales_time= str_to_date(sale_time, '%H:%i:%s');

-- Checking which rows contain Null values.
select * from sales 
where transactions_id is null
or sale_date is null
or customer_id is null 
or gender is null
or age is null
or category is null
or quantiy is null
or price_per_unit is null
or cogs is null
or total_sale is null;

-- Checking the categories.
select distinct category from sales;

-- 1. Write a SQL query to retrieve all columns for sales made on 18-12-2022:
select * from sales
where sale_date = '18-12-2022';

-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is less than 4 in the month of Nov-2022:
SELECT * 
FROM sales
WHERE category = 'Clothing' 
  AND quantiy < 4
  AND sale_date >= '01-11-2022' 
  AND sale_date < '01-12-2022';


-- 3. Write a SQL query to calculate the total sales (total_sale) for each category:
select category, sum(total_sale) as total_sales from sales
group by category;
-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category:
select round(avg(age),2) as avg_age from sales 
where category = 'Beauty';
-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000:
select transactions_id from sales 
where total_sale > 1000;
-- 6. Write a SQL query to find the total number of transactions(transactions_id) made by each gender in each category.
select category, gender, count(transactions_id) as total_number_of_transactions from sales
group by category,gender
order by category;
-- 7. Write a SQL query to calculate the average sale for each month. 
select year(sales_date) as year, month(sales_date) as month, Round(avg(total_sale),2) as Average_Sales from sales
group by year,month
order by year, month; 

-- 8. Write a SQL query to find out the best selling month in each year.
SELECT year, month, Average_Sales
FROM (
    SELECT
        YEAR(sales_date) AS year,
        MONTH(sales_date) AS month,
        ROUND(AVG(total_sale), 2) AS Average_Sales,
        RANK() OVER (
            PARTITION BY YEAR(sales_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rnk
    FROM sales
    GROUP BY YEAR(sales_date), MONTH(sales_date)
) AS t1
WHERE rnk = 1;

-- 9. Write a SQL query to find the top 5 customers based on the highest total sales
select customer_id, sum(total_sale) as total_sales
from sales
group by customer_id
order by total_sales desc
limit 5;

-- 10. Write a SQL query to find the number of unique customers who purchased items from each category.
select category, count(distinct customer_id) as Unique_Customer_Number
from sales
group by category;


-- 11. Write a SQl query to create  each shift and number of orders (Example Morning <= 12, Afternoon between 12  and 17, Evening > 17)
select  
case
	when hour(sales_time)<=12 then 'Morning'
    when hour(sales_time) between 12 and 17 then 'Afternoon'
    else 'Evening'
    end as shift,
count(*) as number_of_orders
from sales
group by shift;











