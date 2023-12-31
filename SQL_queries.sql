-- Create database
CREATE DATABASE IF NOT EXISTS walmartSales;


-- Create table
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);


-- Data cleaning
SELECT
	*
FROM sales;

-- -----------------------------------------------------------------------------------
-- ------------------------------------- Feature Engineering ------------------------------


-- ---------- Time of day ----------

select time ,
(case 
	when time between '00:00:00' and '12:00:00' then 'Morning'
	when time between '12:00:00' and '16:00:00' then 'Afternoon'
	else 'Evening' end
) as time_of_date 

from sales


alter table sales add column time_of_day varchar(20)


update sales 
set time_of_day = (case 
	when time between '00:00:00' and '12:00:00' then 'Morning'
	when time between '12:00:00' and '16:00:00' then 'Afternoon'
	else 'Evening' end
)


-- ---------- day name ----------

select date, dayname(date) from sales;

alter table sales add column day_name varchar(10)

update sales set day_name = dayname(date)


-- ---------------- Month name -----------------


select date, Monthname(date) from sales;

alter table sales add column month_name varchar(20)

update sales 
set month_name = Monthname(date)


-- --------------------------------------------------------------------
-- ---------------------------- Generic ------------------------------
-- --------------------------------------------------------------------


-- How many unique cities does the data have?

select distinct city from sales


-- --------------------------------------------------------------------
-- ---------------------------- Product -------------------------------
-- --------------------------------------------------------------------

-- How many unique product lines does the data have?

select distinct product_line from sales


-- What is the most selling product line

select Product_line, sum(quantity) as qty from sales
group by Product_line
order by qty desc
limit 1

-- What is the total revenue by month

select month_name, sum(total) as total_revenue from sales
group by month_name
order by total_revenue


-- What month had the largest COGS?

select month_name, sum(cogs) cogs from sales
group by month_name
order by cogs desc


-- What product line had the largest revenue?

select product_line, sum(total) as largest_revenue from sales
group by product_line 
order by largest_revenue desc

-- What is the city with the largest revenue?

select city, branch, sum(total) as largest_revenue from sales
group by city, branch
order by largest_revenue desc

-- What is the most common payment method?

select payment, count(payment) as pmt from sales
group by payment
order by pmt desc

-- What product line had the largest VAT?

select product_line, avg(tax_pct) as avg_tax from sales
group by product_line
order by avg_tax desc

-- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales


select avg(quantity) as qty from sales

select product_line,
(case
  when avg(quantity) > 5.4995 then 'Good'
  else 'Bad'
  end) as qtyy
from sales
GROUP BY product_line;


-- Which branch sold more products than average product sold?


select branch, sum(quantity) as qty from sales
group by branch
having qty > avg(quantity)
order by qty desc

-- What is the most common product line by gender

select gender, product_line, count(gender) from sales
group by gender, product_line
order by product_line

-- What is the average rating of each product line

select product_line, Round(avg(rating)) as rating from sales
group by product_line
order by rating desc

-- --------------------------------------------------------------------
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- -------------------------- Customers -------------------------------
-- --------------------------------------------------------------------


-- How many unique customer types does the data have?

select distinct customer_type from sales


-- How many unique payment methods does the data have?

select distinct payment from sales

-- What is the most common customer type?

select customer_type, count(customer_type) as CT from sales
group by customer_type


-- What is the gender of most of the customers?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sales
GROUP BY gender
ORDER BY gender_cnt DESC;

-- What is the gender distribution per branch?

select branch, gender, count(gender) as g from sales
group by branch, gender
order by g desc

-- Which time of the day do customers give most ratings?

select time_of_day, AVG(rating) as r from sales
group by time_of_day
order by r desc

-- Which time of the day do customers give most ratings per branch?

select branch , time_of_day, AVG(rating) as r from sales
group by time_of_day , branch
order by r desc

-- Which day of the week has the best avg ratings?

select day_name , AVG(rating) as r from sales
group by day_name
order by r desc

-- Which day of the week has the best average ratings per branch?

select branch, day_name , AVG(rating) as r from sales
group by  branch,day_name
order by r desc

-- --------------------------------------------------------------------
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- ---------------------------- Sales ---------------------------------
-- --------------------------------------------------------------------


-- Number of sales made in each time of the day per weekday 

select time_of_day, count(*)  as s from sales
group by time_of_day
order by s desc

-- Which of the customer types brings the most revenue?


select customer_type, sum(total) as total from sales
group by customer_type
order by total


-- Which city has the largest tax/VAT percent?


select city, Round(avg(tax_pct),2) as tax from sales
group by city
order by tax

-- Which customer type pays the most in VAT?


select customer_type, Round(avg(tax_pct),2) as tax from sales
group by customer_type
order by tax desc
























