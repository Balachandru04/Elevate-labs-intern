SELECT COUNT(*) FROM `amazon sale report`;

-- rename the table
RENAME TABLE `amazon sale report` TO amazon_sales_report;

select*from amazon_sales_report;

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'amazon_sales_report';

-- Use SELECT, WHERE, ORDER BY, GROUP BY
SELECT 'Order ID', sku, 'ship city', amount, currency
FROM amazon_sales_report
WHERE currency = 'INR'
ORDER BY amount DESC
LIMIT 10;

-- GroupBy
SELECT status, COUNT(*) AS total_orders
FROM amazon_sales_report
GROUP BY status
ORDER BY total_orders DESC;







-- Table 1: Orders
CREATE TABLE orders (
    order_id VARCHAR(50),
    order_date DATE,
    status VARCHAR(50),
    fulfilment VARCHAR(50),
    sales_channel VARCHAR(50),
    amount DECIMAL(10,2),
    currency VARCHAR(10),
    b2b BOOLEAN,
    fulfilled_by VARCHAR(50),
    sku VARCHAR(100)
);

-- Table 2: Products
CREATE TABLE products (
    sku VARCHAR(100),
    style VARCHAR(100),
    category VARCHAR(100),
    size VARCHAR(50),
    asin VARCHAR(20)
);


-- Table 3: Shipping
CREATE TABLE shipping (
    order_id VARCHAR(50),
    ship_service_level VARCHAR(50),
    courier_status VARCHAR(50),
    ship_city VARCHAR(100),
    ship_state VARCHAR(100),
    ship_postal_code VARCHAR(20),
    ship_country VARCHAR(50)
);


-- Insert into orders
INSERT INTO orders (order_id, order_date, status, fulfilment, sales_channel, amount, currency, b2b, fulfilled_by, sku)
SELECT DISTINCT 
  `Order ID`, 
  STR_TO_DATE(`Date`, '%m-%d-%y'), 
  `Status`, 
  `Fulfilment`, 
  `Sales Channel`, 
  `Amount`, 
  `currency`, 
  CASE 
    WHEN `B2B` = 'TRUE' THEN 1 
    WHEN `B2B` = 'FALSE' THEN 0 
    ELSE NULL 
  END, 
  `fulfilled-by`, 
  `SKU`
FROM amazon_sales_report;

select count(*) from orders;

-- Insert into products
INSERT INTO products (sku, style, category, size, asin)
SELECT DISTINCT sku, style, category, size, asin
FROM amazon_sales_report;


select count(*) from products;

-- Insert into shipping
INSERT INTO shipping (order_id, ship_service_level, courier_status, ship_city, ship_state, ship_postal_code, ship_country)
SELECT DISTINCT `Order ID`, `ship-service-level`, `Courier Status`, `ship-city`, `ship-state`, `ship-postal-code`, `ship-country`
FROM amazon_sales_report;

select count(*) from shipping;

-- inner join
SELECT 
    o.order_id,
    o.order_date,
    p.category,
    o.amount,
    s.ship_city,
    s.courier_status
FROM orders o
INNER JOIN products p ON o.sku = p.sku
INNER JOIN shipping s ON o.order_id = s.order_id
LIMIT 10;

-- Left join

SELECT 
    o.order_id,
    o.order_date,
    p.category,
    s.ship_city,
    s.courier_status
FROM orders o
LEFT JOIN products p ON o.sku = p.sku
LEFT JOIN shipping s ON o.order_id = s.order_id
LIMIT 10;


-- Right join

SELECT 
    s.order_id,
    o.order_date,
    p.category,
    s.ship_city,
    s.courier_status
FROM shipping s
RIGHT JOIN orders o ON s.order_id = o.order_id
RIGHT JOIN products p ON o.sku = p.sku
LIMIT 10;


-- FULL OUTER JOIN using UNION
SELECT 
    o.order_id,
    o.order_date,
    s.ship_city,
    s.courier_status
FROM orders o LEFT JOIN shipping s ON o.order_id = s.order_id
UNION
SELECT 
    o.order_id,
    o.order_date,
    s.ship_city,
    s.courier_status
FROM shipping s
LEFT JOIN orders o ON o.order_id = s.order_id limit 10;

-- subqueries

SELECT order_id, amount, currency
FROM orders
WHERE amount > (
    SELECT AVG(amount) FROM orders
);

-- Find all orders that used the same courier status as the top order (by amount)

SELECT o.order_id, o.amount, s.courier_status
FROM orders o
JOIN shipping s ON o.order_id = s.order_id
WHERE s.courier_status = (
    SELECT s2.courier_status
    FROM orders o2
    JOIN shipping s2 ON o2.order_id = s2.order_id
    ORDER BY o2.amount DESC
    LIMIT 1
) limit 10;


-- useful aggregate query

SELECT SUM(amount) AS total_sales_inr
FROM orders
WHERE currency = 'INR';

SELECT fulfilment, AVG(amount) AS avg_order_amount
FROM orders
GROUP BY fulfilment;


-- view
-- 1. View: High Value INR Orders

CREATE VIEW high_value_inr_orders AS
SELECT order_id, order_date, sku, amount, currency
FROM orders
WHERE currency = 'INR' AND amount > 2000;
select * from high_value_inr_orders;

-- 2. View: Total Sales by City
CREATE VIEW total_sales_by_city AS
SELECT s.ship_city, SUM(o.amount) AS total_sales
FROM orders o
JOIN shipping s ON o.order_id = s.order_id
GROUP BY s.ship_city;

select * from total_sales_by_city;

--  Index on order_id

CREATE INDEX idx_order_id ON orders(order_id);

SELECT *
FROM orders o
JOIN shipping s ON o.order_id = s.order_id
WHERE o.order_id = '171-0022303-3275527';

