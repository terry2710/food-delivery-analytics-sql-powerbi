SELECT
    `Restaurant_ID`,
    `Restaurant_name`,
    `City`,
    `Subzone`,
    COUNT(DISTINCT `Order_ID`) AS total_orders,
    COUNT(DISTINCT `Customer_ID`) AS unique_customers,
    ROUND(SUM(`net_order_value`), 2) AS total_revenue,
    ROUND(AVG(`net_order_value`), 2) AS avg_order_value,
    ROUND(AVG(`discount_rate`), 4) AS avg_discount_rate,
    ROUND(AVG(CASE WHEN `Rating` IS NOT NULL THEN `Rating` END), 2) AS avg_rating,
    ROUND(AVG(`KPT_duration_minutes`), 2) AS avg_kpt_minutes,
    ROUND(AVG(`Rider_wait_time_minutes`), 2) AS avg_rider_wait_minutes
FROM food_orders
WHERE `is_delivered` = 1
GROUP BY
    `Restaurant_ID`,
    `Restaurant_name`,
    `City`,
    `Subzone`
ORDER BY total_revenue DESC, total_orders DESC;