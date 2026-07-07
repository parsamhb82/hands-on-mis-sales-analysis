.headers on
.mode column

/*
Promotional Campaign Analysis

Purpose:
Identify stores and sales regions that may benefit from additional marketing.

Business logic:
Low-performing regions and sellers may need promotional campaigns, better
marketing support, or pricing strategy changes.

In this dataset:
- seller_id represents a store/seller
- seller_state represents a sales region
*/


/*
Recreate the base view to make this SQL file runnable independently.
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
Query 2A:
Sales performance by region.
This shows total sales activity by seller state.
*/

SELECT
    seller_state AS region,
    COUNT(*) AS units_sold,
    COUNT(DISTINCT seller_id) AS number_of_sellers,
    ROUND(SUM(price), 2) AS total_revenue,
    ROUND(AVG(price), 2) AS average_price
FROM sales_analysis_base
GROUP BY seller_state
ORDER BY total_revenue ASC;


/*
Query 2B:
Lowest-performing regions by revenue.

These regions are candidates for additional marketing because their total sales
revenue is low compared with other regions.
*/

SELECT
    seller_state AS region,
    COUNT(*) AS units_sold,
    COUNT(DISTINCT seller_id) AS number_of_sellers,
    ROUND(SUM(price), 2) AS total_revenue,
    ROUND(AVG(price), 2) AS average_price
FROM sales_analysis_base
GROUP BY seller_state
ORDER BY total_revenue ASC
LIMIT 10;


/*
Query 2C:
Highest-performing regions by revenue.

This gives a comparison point for identifying stronger and weaker regions.
*/

SELECT
    seller_state AS region,
    COUNT(*) AS units_sold,
    COUNT(DISTINCT seller_id) AS number_of_sellers,
    ROUND(SUM(price), 2) AS total_revenue,
    ROUND(AVG(price), 2) AS average_price
FROM sales_analysis_base
GROUP BY seller_state
ORDER BY total_revenue DESC
LIMIT 10;


/*
Query 2D:
Lowest-performing sellers with at least 20 units sold.

The filter avoids sellers with only one or two sales, because those may not be
meaningful enough for a promotional campaign.
*/

SELECT
    seller_id,
    seller_state AS region,
    COUNT(*) AS units_sold,
    ROUND(SUM(price), 2) AS total_revenue,
    ROUND(AVG(price), 2) AS average_price
FROM sales_analysis_base
GROUP BY seller_id, seller_state
HAVING units_sold >= 20
ORDER BY total_revenue ASC
LIMIT 15;


/*
Query 2E:
Highest-performing sellers.

This helps compare low-performing sellers with successful sellers.
*/

SELECT
    seller_id,
    seller_state AS region,
    COUNT(*) AS units_sold,
    ROUND(SUM(price), 2) AS total_revenue,
    ROUND(AVG(price), 2) AS average_price
FROM sales_analysis_base
GROUP BY seller_id, seller_state
ORDER BY total_revenue DESC
LIMIT 15;