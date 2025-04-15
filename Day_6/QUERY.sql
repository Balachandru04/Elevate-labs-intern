CREATE DATABASE sales_db;

USE sales_db;

SET SQL_SAFE_UPDATES = 1;
CREATE TABLE sales_transactions (
    transaction_id INT PRIMARY KEY,
    transaction_date DATE,
    product_category VARCHAR(100),
    product_name VARCHAR(255),
    units_sold INT,
    unit_price DECIMAL(10,2),
    total_revenue DECIMAL(10,2),
    region VARCHAR(100),
    payment_method VARCHAR(50)
);

-- View table
SELECT * FROM sales_transactions;
SELECT count(*) FROM sales_transactions;

-- Load CSV into table
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Online Sales Data.csv'
INTO TABLE sales_transactions
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- extract month name  from date col and add the col to table
ALTER TABLE sales_transactions ADD COLUMN month VARCHAR(20);

UPDATE sales_transactions SET month = MONTHNAME(transaction_date);

-- extract year from date col and add the col to table
ALTER TABLE sales_transactions ADD COLUMN year VARCHAR(20);

UPDATE sales_transactions SET year = year(transaction_date);


-- group by 

-- by monthly transactions
SELECT month, COUNT(*) AS total_transactions
FROM sales_transactions
GROUP BY month;

-- average revenue by month 
SELECT month, avg(total_revenue) AS average_monthly_revenue
FROM sales_transactions
GROUP BY month;

-- group by product name with total revenue
SELECT month, product_name, sum(total_revenue) AS total_revenue
FROM sales_transactions
GROUP BY month,product_name;


-- group by product name with total revenue
SELECT product_category, sum(total_revenue) AS total_revenue_product_category
FROM sales_transactions
GROUP BY product_category;

-- group_by region with total revenue
SELECT region, sum(total_revenue) AS total_revenue_region
FROM sales_transactions
GROUP BY region;


-- group_by product category by unit sold 
SELECT product_category, sum(units_sold) AS total_revenue_region
FROM sales_transactions
GROUP BY product_category;


-- unique product_names in sales_transactions;
select distinct product_name from sales_transactions;
select count(distinct product_name) as count_product_name  from sales_transactions;


-- total revenue by month
SELECT month, SUM(total_revenue) AS total_monthly_revenue
FROM sales_transactions
GROUP BY month
ORDER BY FIELD(month, 'January', 'February', 'March', 'April', 'May', 'June','July', 'August', 'September', 'October', 'November', 'December');

-- order by in product category with total revenur
SELECT product_category, SUM(total_revenue) AS total_revenue
FROM sales_transactions
GROUP BY product_category
ORDER BY  total_revenue desc;

-- only first 10 rows
select * from sales_transactions limit 10;

-- top 5 product category revenue
SELECT product_category, SUM(total_revenue) AS total_revenue
FROM sales_transactions
GROUP BY product_category
ORDER BY  total_revenue desc
limit 5;