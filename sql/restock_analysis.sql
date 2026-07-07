.headers on
.mode column

/*
Restocking Analysis

Purpose:
Identify product categories and individual products with the highest sales demand.

Business logic:
Because the dataset does not include current inventory levels, units sold are used
as a demand indicator. Products with high units sold should be prioritized for
restocking.
*/


/*
Query 1A:
Top product categories by units sold.
*/

SELECT
    product_category_name AS product_category,
    COUNT(*) AS units_sold,
    ROUND(SUM(price), 2) AS total_revenue,
    ROUND(AVG(price), 2) AS average_price
FROM sales_analysis_base
GROUP BY product_category_name
ORDER BY units_sold DESC
LIMIT 15;


/*
Query 1B:
Top individual products by units sold.
*/

SELECT
    product_id,
    product_category_name AS product_category,
    COUNT(*) AS units_sold,
    ROUND(SUM(price), 2) AS total_revenue,
    ROUND(AVG(price), 2) AS average_price
FROM sales_analysis_base
GROUP BY product_id, product_category_name
ORDER BY units_sold DESC
LIMIT 15;


/*
Query 1C:
High-revenue product categories.
This helps managers identify products that are not only popular,
but also financially important.
*/

SELECT
    product_category_name AS product_category,
    COUNT(*) AS units_sold,
    ROUND(SUM(price), 2) AS total_revenue,
    ROUND(AVG(price), 2) AS average_price
FROM sales_analysis_base
GROUP BY product_category_name
ORDER BY total_revenue DESC
LIMIT 15;