.headers on
.mode column

/*
Pricing Timing Analysis

Purpose:
Identify when products should be offered at full price and when discounts
or promotions should be used.

Business logic:
The dataset does not contain a discount field. Therefore, sales volume and
monthly revenue are used to identify high-demand and low-demand periods.

High-demand months:
- stronger sales volume
- higher revenue
- better candidates for full-price selling

Low-demand months:
- weaker sales volume
- lower revenue
- better candidates for discounts and promotions
*/


/*
Recreate the base view so this file can run independently.
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
Query 3A:
Sales by month across the whole dataset.
*/

SELECT
    order_month AS month_number,
    COUNT(*) AS units_sold,
    ROUND(SUM(price), 2) AS total_revenue,
    ROUND(AVG(price), 2) AS average_price
FROM sales_analysis_base
GROUP BY order_month
ORDER BY month_number;


/*
Query 3B:
Best months by total revenue.
These months are stronger candidates for full-price selling.
*/

SELECT
    order_month AS month_number,
    COUNT(*) AS units_sold,
    ROUND(SUM(price), 2) AS total_revenue,
    ROUND(AVG(price), 2) AS average_price
FROM sales_analysis_base
GROUP BY order_month
ORDER BY total_revenue DESC
LIMIT 5;


/*
Query 3C:
Weakest months by total revenue.
These months are stronger candidates for discounts or promotions.
*/

SELECT
    order_month AS month_number,
    COUNT(*) AS units_sold,
    ROUND(SUM(price), 2) AS total_revenue,
    ROUND(AVG(price), 2) AS average_price
FROM sales_analysis_base
GROUP BY order_month
ORDER BY total_revenue ASC
LIMIT 5;


/*
Query 3D:
Sales by year-month for more detailed time trend analysis.
*/

SELECT
    order_year_month,
    COUNT(*) AS units_sold,
    ROUND(SUM(price), 2) AS total_revenue,
    ROUND(AVG(price), 2) AS average_price
FROM sales_analysis_base
GROUP BY order_year_month
ORDER BY order_year_month;


/*
Query 3E:
Strongest individual year-month periods.
*/

SELECT
    order_year_month,
    COUNT(*) AS units_sold,
    ROUND(SUM(price), 2) AS total_revenue,
    ROUND(AVG(price), 2) AS average_price
FROM sales_analysis_base
GROUP BY order_year_month
ORDER BY total_revenue DESC
LIMIT 10;


/*
Query 3F:
Weakest individual year-month periods.

The very beginning and ending months may be incomplete because the dataset
does not cover full calendar years, so these should be interpreted carefully.
*/

SELECT
    order_year_month,
    COUNT(*) AS units_sold,
    ROUND(SUM(price), 2) AS total_revenue,
    ROUND(AVG(price), 2) AS average_price
FROM sales_analysis_base
GROUP BY order_year_month
ORDER BY total_revenue ASC
LIMIT 10;