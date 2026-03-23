-- ============================================================
-- Part 5 — Data Lake & DuckDB Cross-Format Queries
-- Files read directly — no pre-loading into tables
-- customers.csv | orders.json | products.parquet
-- ============================================================

-- Q1: List all customers along with the total number of orders they have placed
SELECT
    c.customer_id,
    c.name               AS customer_name,
    c.city,
    COUNT(o.order_id)    AS total_orders
FROM read_csv_auto('/datasets/customers.csv') AS c
LEFT JOIN read_json_auto('/datasets/orders.json') AS o
       ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name, c.city
ORDER BY total_orders DESC;

-- Q2: Find the top 3 customers by total order value
SELECT
    c.customer_id,
    c.name               AS customer_name,
    c.city,
    SUM(o.total_amount)  AS total_order_value
FROM read_csv_auto('/datasets/customers.csv') AS c
JOIN read_json_auto('/datasets/orders.json') AS o
  ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name, c.city
ORDER BY total_order_value DESC
LIMIT 3;

-- Q3: List all products purchased by customers from Bangalore
SELECT DISTINCT
    p.product_name,
    p.category,
    p.unit_price
FROM read_csv_auto('/datasets/customers.csv')    AS c
JOIN read_json_auto('/datasets/orders.json')     AS o  ON c.customer_id = o.customer_id
JOIN read_parquet('/datasets/products.parquet')  AS li ON o.order_id     = li.order_id
JOIN (
    SELECT DISTINCT product_id, product_name, category, unit_price
    FROM read_parquet('/datasets/products.parquet')
) AS p ON li.product_id = p.product_id
WHERE c.city = 'Bangalore'
ORDER BY p.category, p.product_name;

-- Q4: Join all three files to show: customer name, order date, product name, and quantity
SELECT
    c.name          AS customer_name,
    c.city          AS customer_city,
    o.order_date,
    o.status        AS order_status,
    p.product_name,
    p.category,
    li.quantity,
    li.unit_price,
    li.total_price
FROM read_csv_auto('/datasets/customers.csv')    AS c
JOIN read_json_auto('/datasets/orders.json')     AS o  ON c.customer_id = o.customer_id
JOIN read_parquet('/datasets/products.parquet')  AS li ON o.order_id    = li.order_id
JOIN (
    SELECT DISTINCT product_id, product_name, category, unit_price
    FROM read_parquet('/datasets/products.parquet')
) AS p ON li.product_id = p.product_id
ORDER BY o.order_date DESC, c.name;
