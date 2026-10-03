USE retail_analytics;

-- ============================================================
-- 1. OVERALL BUSINESS PERFORMANCE
-- ============================================================

SELECT
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    SUM(sales) / COUNT(DISTINCT order_id) AS average_order_value,
    SUM(profit) / SUM(sales) * 100 AS profit_margin_pct
FROM superstore_sales;

-- ============================================================
-- 2. YEARLY SALES AND PROFIT PERFORMANCE
-- ============================================================

SELECT
    YEAR(order_date) AS order_year,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) / SUM(sales) * 100 AS profit_margin_pct
FROM superstore_sales
GROUP BY YEAR(order_date)
ORDER BY order_year;

-- ============================================================
-- 3. YEAR-OVER-YEAR GROWTH
-- ============================================================

WITH yearly_performance AS (
    SELECT
        YEAR(order_date) AS order_year,
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit
    FROM superstore_sales
    GROUP BY YEAR(order_date)
)
SELECT
    order_year,
    total_sales,
    total_profit,
    LAG(total_sales) OVER (ORDER BY order_year) AS previous_year_sales,

    (total_sales - LAG(total_sales) OVER (ORDER BY order_year))
        / LAG(total_sales) OVER (ORDER BY order_year) * 100 AS sales_growth_pct,

    LAG(total_profit) OVER (ORDER BY order_year) AS previous_year_profit,

    (total_profit - LAG(total_profit) OVER (ORDER BY order_year))
        / LAG(total_profit) OVER (ORDER BY order_year) * 100 AS profit_growth_pct
FROM yearly_performance
ORDER BY order_year;

-- ============================================================
-- 4. SALES AND PROFIT BY CATEGORY
-- ============================================================

SELECT
    category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) / SUM(sales) * 100 AS profit_margin_pct
FROM superstore_sales
GROUP BY category
ORDER BY total_sales DESC;

SELECT
    sub_category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) / SUM(sales) * 100 AS profit_margin_pct
FROM superstore_sales
WHERE category = 'Furniture'
GROUP BY sub_category
ORDER BY profit_margin_pct ASC;

SELECT
    discount,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) / SUM(sales) * 100 AS profit_margin_pct
FROM superstore_sales
WHERE sub_category = 'Tables'
GROUP BY discount
ORDER BY discount;

SELECT
    discount,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) / SUM(sales) * 100 AS profit_margin_pct
FROM superstore_sales
WHERE sub_category = 'Bookcases'
GROUP BY discount
ORDER BY discount;

SELECT
    sub_category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(sales) / (
        SELECT SUM(sales)
        FROM superstore_sales
        WHERE category = 'Furniture'
    ) * 100 AS sales_share_pct
FROM superstore_sales
WHERE category = 'Furniture'
GROUP BY sub_category
ORDER BY total_sales DESC;

SELECT
    sub_category,
    product_name,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) / SUM(sales) * 100 AS profit_margin_pct
FROM superstore_sales
WHERE sub_category IN ('Tables', 'Bookcases')
GROUP BY sub_category, product_name
ORDER BY total_profit ASC;

SELECT
    product_name,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    AVG(discount) * 100 AS avg_discount_pct,
    SUM(profit) / SUM(sales) * 100 AS profit_margin_pct
FROM superstore_sales
WHERE sub_category = 'Tables'
GROUP BY product_name
ORDER BY total_profit ASC;


WITH discount_analysis AS (
    SELECT
        CASE
            WHEN discount = 0 THEN '0%'
            WHEN discount <= 0.20 THEN '1-20%'
            WHEN discount <= 0.25 THEN '21-25%'
            ELSE 'Above 25%'
        END AS discount_band,
        CASE
            WHEN discount = 0 THEN 1
            WHEN discount <= 0.20 THEN 2
            WHEN discount <= 0.25 THEN 3
            ELSE 4
        END AS band_order,
        sales,
        profit
    FROM superstore_sales
    WHERE sub_category = 'Tables'
)
SELECT
    discount_band,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) * 100.0 / NULLIF(SUM(sales), 0) AS profit_margin_pct
FROM discount_analysis
GROUP BY discount_band, band_order
ORDER BY band_order;

SELECT
    product_name,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    AVG(discount) as avg_discount,
    AVG(discount) * 100 AS avg_discount_pct,
    SUM(profit) / SUM(sales) * 100 AS profit_margin_pct
FROM superstore_sales
WHERE sub_category = 'Tables'
GROUP BY product_name
ORDER BY total_profit ASC;

select category,
    sub_category,
    SUM(profit) as total_profit,
    SUM(profit)/SUM(sales) *100 as profit_margin_pct
from superstore_sales
group by category,sub_category
order by total_profit desc

SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) / SUM(sales) * 100 AS profit_margin_pct
FROM superstore_sales
GROUP BY
    YEAR(order_date),
    MONTH(order_date)
ORDER BY
    order_year,
    order_month;

    SELECT
    category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) * 100.0 / NULLIF(SUM(sales), 0) AS profit_margin_pct
FROM superstore_sales
WHERE order_date >= '2023-07-01'
  AND order_date < '2023-08-01'
GROUP BY category
ORDER BY total_profit ASC;

SELECT
    sub_category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) * 100.0 / NULLIF(SUM(sales), 0) AS profit_margin_pct
FROM superstore_sales
WHERE order_date >= '2023-07-01'
  AND order_date < '2023-08-01'
  AND category = 'Office Supplies'
GROUP BY sub_category
ORDER BY total_profit ASC;

SELECT
    discount,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) * 100.0 / NULLIF(SUM(sales), 0) AS profit_margin_pct
FROM superstore_sales
WHERE order_date >= '2023-07-01'
  AND order_date < '2023-08-01'
  AND sub_category = 'Binders'
GROUP BY discount
ORDER BY discount;

SELECT
    product_name,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    AVG(discount) * 100 AS avg_discount_pct
FROM superstore_sales
WHERE order_date >= '2023-07-01'
  AND order_date < '2023-08-01'
  AND sub_category = 'Binders'
  AND discount >= 0.8
GROUP BY product_name
ORDER BY total_profit ASC;

SELECT
    discount,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) * 100.0 / NULLIF(SUM(sales), 0) AS profit_margin_pct
FROM superstore_sales
GROUP BY discount
ORDER BY discount;

SELECT
    segment,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) * 100.0 / NULLIF(SUM(sales), 0) AS profit_margin_pct,
    COUNT(DISTINCT customer_id) AS total_customers,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore_sales
GROUP BY segment
ORDER BY total_sales DESC;

SELECT TOP 15
    customer_id,
    customer_name,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) * 100.0 / NULLIF(SUM(sales), 0) AS profit_margin_pct
FROM superstore_sales
GROUP BY customer_id, customer_name
ORDER BY total_profit DESC;

SELECT
    segment,
    category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) * 100.0 / NULLIF(SUM(sales), 0) AS profit_margin_pct
FROM superstore_sales
GROUP BY segment, category
ORDER BY segment, profit_margin_pct;

SELECT
    category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) * 100.0 / NULLIF(SUM(sales), 0) AS profit_margin_pct
FROM superstore_sales
GROUP BY category
ORDER BY profit_margin_pct;

SELECT
    segment,
    sub_category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) * 100.0 / NULLIF(SUM(sales), 0) AS profit_margin_pct
FROM superstore_sales
WHERE category = 'Furniture'
GROUP BY segment, sub_category
ORDER BY segment, profit_margin_pct;

SELECT
    segment,
    discount,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) * 100.0 / NULLIF(SUM(sales), 0) AS profit_margin_pct
FROM superstore_sales
WHERE sub_category = 'Bookcases'
GROUP BY segment, discount
ORDER BY segment, discount;

SELECT
    customer_id,
    customer_name,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM superstore_sales
GROUP BY customer_id, customer_name
ORDER BY total_profit DESC;

SELECT
    COUNT(*) AS loss_making_customers,
    SUM(total_sales) AS sales_from_loss_making_customers,
    SUM(total_profit) AS total_loss
FROM (
    SELECT
        customer_id,
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit
    FROM superstore_sales
    GROUP BY customer_id
    HAVING SUM(profit) < 0
) AS customer_profitability;

SELECT TOP 15
    customer_id,
    customer_name,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) * 100.0 / NULLIF(SUM(sales), 0) AS profit_margin_pct
FROM superstore_sales
GROUP BY customer_id, customer_name
HAVING SUM(profit) < 0
ORDER BY total_profit ASC;

WITH loss_customers AS (
    SELECT customer_id
    FROM superstore_sales
    GROUP BY customer_id
    HAVING SUM(profit) < 0
),
discount_analysis AS (
    SELECT
        CASE
            WHEN discount = 0 THEN '0%'
            WHEN discount <= 0.20 THEN '1-20%'
            WHEN discount <= 0.25 THEN '21-25%'
            ELSE 'Above 25%'
        END AS discount_band,
        CASE
            WHEN discount = 0 THEN 1
            WHEN discount <= 0.20 THEN 2
            WHEN discount <= 0.25 THEN 3
            ELSE 4
        END AS band_order,
        customer_id,
        sales,
        profit
    FROM superstore_sales
    WHERE customer_id IN (SELECT customer_id FROM loss_customers)
)
SELECT
    discount_band,
    COUNT(DISTINCT customer_id) AS customers,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) * 100.0 / NULLIF(SUM(sales), 0) AS profit_margin_pct
FROM discount_analysis
GROUP BY discount_band, band_order
ORDER BY band_order;

SELECT
    region,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) * 100.0 / NULLIF(SUM(sales), 0) AS profit_margin_pct,
    COUNT(DISTINCT customer_id) AS total_customers,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore_sales
GROUP BY region
ORDER BY profit_margin_pct;

SELECT
    region,
    category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) * 100.0 / NULLIF(SUM(sales), 0) AS profit_margin_pct
FROM superstore_sales
GROUP BY
    region,
    category
ORDER BY
    region,
    profit_margin_pct;


SELECT
    region,
    sub_category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) * 100.0 / NULLIF(SUM(sales), 0) AS profit_margin_pct
FROM superstore_sales
WHERE category = 'Furniture'
GROUP BY
    region,
    sub_category
ORDER BY
    region,
    profit_margin_pct;


    SELECT
    region,
    discount,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) * 100.0 / NULLIF(SUM(sales), 0) AS profit_margin_pct
FROM superstore_sales
WHERE sub_category = 'Tables'
GROUP BY
    region,
    discount
ORDER BY
    region,
    discount;

    SELECT TOP 20
    product_name,
    category,
    sub_category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) * 100.0 / NULLIF(SUM(sales), 0) AS profit_margin_pct
FROM superstore_sales
GROUP BY
    product_name,
    category,
    sub_category
ORDER BY
    total_profit ASC;

    SELECT
    product_name,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    AVG(discount) * 100 AS avg_discount_pct,
    SUM(profit) * 100.0 / NULLIF(SUM(sales), 0) AS profit_margin_pct
FROM superstore_sales
WHERE sub_category = 'Machines'
GROUP BY product_name
ORDER BY total_profit ASC;

SELECT
    CASE
        WHEN discount = 0 THEN '0%'
        WHEN discount <= 0.20 THEN '1-20%'
        WHEN discount <= 0.25 THEN '21-25%'
        ELSE 'Above 25%'
    END AS discount_band,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) * 100.0 / NULLIF(SUM(sales), 0) AS profit_margin_pct
FROM superstore_sales
WHERE sub_category = 'Machines'
GROUP BY
    CASE
        WHEN discount = 0 THEN '0%'
        WHEN discount <= 0.20 THEN '1-20%'
        WHEN discount <= 0.25 THEN '21-25%'
        ELSE 'Above 25%'
    END
ORDER BY
    MIN(discount);

    SELECT
    ship_mode,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) * 100.0 / NULLIF(SUM(sales), 0) AS profit_margin_pct,
    AVG(shipping_days) AS avg_shipping_days,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore_sales
GROUP BY ship_mode
ORDER BY profit_margin_pct;

SELECT
    customer_id,
    customer_name,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) * 100.0 / NULLIF(SUM(sales), 0) AS profit_margin_pct
FROM superstore_sales
GROUP BY
    customer_id,
    customer_name
ORDER BY total_orders DESC;

SELECT
    total_orders,
    COUNT(*) AS customer_count,
    AVG(total_sales) AS avg_sales_per_customer,
    AVG(total_profit) AS avg_profit_per_customer,
    AVG(profit_margin_pct) AS avg_profit_margin_pct
FROM (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders,
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit,
        SUM(profit) * 100.0 / NULLIF(SUM(sales), 0) AS profit_margin_pct
    FROM superstore_sales
    GROUP BY customer_id
) AS customer_summary
GROUP BY total_orders
ORDER BY total_orders;

SELECT
    CASE
        WHEN total_profit < 0 THEN 'Loss-making'
        WHEN profit_margin_pct < 5 THEN 'Low-margin'
        WHEN profit_margin_pct < 15 THEN 'Healthy-margin'
        ELSE 'High-margin'
    END AS customer_profitability_group,
    COUNT(*) AS customer_count,
    SUM(total_sales) AS total_sales,
    SUM(total_profit) AS total_profit,
    AVG(profit_margin_pct) AS avg_profit_margin_pct
FROM (
    SELECT
        customer_id,
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit,
        SUM(profit) * 100.0 / NULLIF(SUM(sales), 0) AS profit_margin_pct
    FROM superstore_sales
    GROUP BY customer_id
) AS customer_summary
GROUP BY
    CASE
        WHEN total_profit < 0 THEN 'Loss-making'
        WHEN profit_margin_pct < 5 THEN 'Low-margin'
        WHEN profit_margin_pct < 15 THEN 'Healthy-margin'
        ELSE 'High-margin'
    END
ORDER BY total_profit;

SELECT
    CASE
        WHEN total_profit < 0 THEN 'Loss-making'
        WHEN profit_margin_pct < 5 THEN 'Low-margin'
        WHEN profit_margin_pct < 15 THEN 'Healthy-margin'
        ELSE 'High-margin'
    END AS customer_profitability_group,
    AVG(avg_discount) AS avg_customer_discount,
    AVG(profit_margin_pct) AS avg_profit_margin_pct,
    SUM(total_sales) AS total_sales,
    SUM(total_profit) AS total_profit,
    COUNT(*) AS customer_count
FROM (
    SELECT
        customer_id,
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit,
        AVG(discount) AS avg_discount,
        SUM(profit) * 100.0 / NULLIF(SUM(sales), 0) AS profit_margin_pct
    FROM superstore_sales
    GROUP BY customer_id
) AS customer_summary
GROUP BY
    CASE
        WHEN total_profit < 0 THEN 'Loss-making'
        WHEN profit_margin_pct < 5 THEN 'Low-margin'
        WHEN profit_margin_pct < 15 THEN 'Healthy-margin'
        ELSE 'High-margin'
    END
ORDER BY avg_customer_discount;

SELECT
    category,
    COUNT(DISTINCT customer_id) AS loss_making_customers,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) * 100.0 / NULLIF(SUM(sales), 0) AS profit_margin_pct,
    AVG(discount) AS avg_discount
FROM superstore_sales
WHERE customer_id IN (
    SELECT customer_id
    FROM superstore_sales
    GROUP BY customer_id
    HAVING SUM(profit) < 0
)
GROUP BY category
ORDER BY total_profit ASC;

SELECT
    category,
    sub_category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) * 100.0 / NULLIF(SUM(sales), 0) AS profit_margin_pct,
    AVG(discount) AS avg_discount
FROM superstore_sales
WHERE customer_id IN (
    SELECT customer_id
    FROM superstore_sales
    GROUP BY customer_id
    HAVING SUM(profit) < 0
)
GROUP BY category, sub_category
ORDER BY total_profit ASC;

SELECT
    category,
    sub_category,
    product_name,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) * 100.0 / NULLIF(SUM(sales), 0) AS profit_margin_pct,
    AVG(discount) AS avg_discount
FROM superstore_sales
WHERE customer_id IN (
    SELECT customer_id
    FROM superstore_sales
    GROUP BY customer_id
    HAVING SUM(profit) < 0
)
GROUP BY
    category,
    sub_category,
    product_name
HAVING SUM(profit) < 0
ORDER BY total_profit ASC;

SELECT TOP 10
    product_name,
    COUNT(DISTINCT customer_id) AS customers,
    COUNT(DISTINCT order_id) AS orders,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) * 100.0 / NULLIF(SUM(sales), 0) AS profit_margin_pct,
    AVG(discount) AS avg_discount
FROM superstore_sales
WHERE customer_id IN (
    SELECT customer_id
    FROM superstore_sales
    GROUP BY customer_id
    HAVING SUM(profit) < 0
)
GROUP BY product_name
HAVING SUM(profit) < 0
ORDER BY total_profit ASC;

SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    DATEFROMPARTS(
        YEAR(order_date),
        MONTH(order_date),
        1
    ) AS month_date,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) * 100.0 / NULLIF(SUM(sales), 0) AS profit_margin_pct,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers
FROM superstore_sales
GROUP BY
    YEAR(order_date),
    MONTH(order_date),
    DATEFROMPARTS(
        YEAR(order_date),
        MONTH(order_date),
        1
    )
ORDER BY month_date;


SELECT
    category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) * 100.0 / NULLIF(SUM(sales), 0) AS profit_margin_pct,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    AVG(discount) * 100 AS avg_discount_pct
FROM superstore_sales
GROUP BY category
ORDER BY total_profit DESC;

SELECT
    category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) * 100.0 / NULLIF(SUM(sales), 0) AS profit_margin_pct,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    AVG(discount) * 100 AS avg_discount_pct
FROM superstore_sales
GROUP BY category
ORDER BY total_profit DESC;

SELECT
    region,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) * 100.0 / NULLIF(SUM(sales), 0) AS profit_margin_pct,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    AVG(discount) * 100 AS avg_discount_pct
FROM superstore_sales
GROUP BY region
ORDER BY total_profit DESC;

SELECT
    discount * 100 AS discount_pct,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) * 100.0 / NULLIF(SUM(sales), 0) AS profit_margin_pct,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers
FROM superstore_sales
GROUP BY discount
ORDER BY discount;


SELECT TOP 20
    product_name,
    category,
    sub_category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) * 100.0 / NULLIF(SUM(sales), 0) AS profit_margin_pct,
    AVG(discount) * 100 AS avg_discount_pct,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore_sales
GROUP BY
    product_name,
    category,
    sub_category
HAVING SUM(profit) < 0
ORDER BY total_profit ASC;


SELECT
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) * 100.0 / NULLIF(SUM(sales), 0) AS profit_margin_pct,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    COUNT(DISTINCT product_id) AS total_products,
    AVG(discount) * 100 AS avg_discount_pct
FROM superstore_sales;