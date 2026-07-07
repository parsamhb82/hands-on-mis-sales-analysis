.headers on
.mode column

/*
Hands-On MIS Sales Analysis Queries

This file prepares the dataset for the Chapter 1 MIS database analysis project.
The main goal is to answer:

1. Which products should be restocked?
2. Which stores and sales regions need promotional campaigns?
3. When should products be sold at full price or discounted?
*/


/*
SECTION 1: Database Profile
*/

SELECT 'orders' AS table_name, COUNT(*) AS row_count FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL
SELECT 'order_reviews', COUNT(*) FROM order_reviews;


/*
SECTION 2: Date Range
*/

SELECT
    MIN(timestamp) AS first_order_date,
    MAX(timestamp) AS last_order_date
FROM orders;


/*
SECTION 3: Main Sales Analysis View

Each row in order_items represents one sold item.
So COUNT(*) can be used as units_sold.
*/

DROP VIEW IF EXISTS sales_analysis_base;

CREATE VIEW sales_analysis_base AS
SELECT
    oi.order_items_pk,
    o.order_id,
    DATE(o.timestamp) AS order_date,
    STRFTIME('%Y', o.timestamp) AS order_year,
    STRFTIME('%m', o.timestamp) AS order_month,
    STRFTIME('%Y-%m', o.timestamp) AS order_year_month,
    oi.product_id,
    p.product_category_name,
    oi.seller_id,
    s.seller_state,
    oi.price
FROM order_items AS oi
JOIN orders AS o
    ON oi.order_id = o.order_id
LEFT JOIN products AS p
    ON oi.product_id = p.product_id
LEFT JOIN sellers AS s
    ON oi.seller_id = s.seller_id;


/*
SECTION 4: View Check
*/

SELECT
    COUNT(*) AS total_sales_rows
FROM sales_analysis_base;


/*
SECTION 5: Sample Rows
*/

SELECT
    order_date,
    order_year_month,
    seller_state,
    product_category_name,
    price
FROM sales_analysis_base
LIMIT 10;


/*
SECTION 6: Missing Data Check
*/

SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN product_category_name IS NULL THEN 1 ELSE 0 END) AS missing_product_category,
    SUM(CASE WHEN seller_state IS NULL THEN 1 ELSE 0 END) AS missing_seller_state,
    SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) AS missing_price
FROM sales_analysis_base;