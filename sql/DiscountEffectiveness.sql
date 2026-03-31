SELECT
    CASE
        WHEN `discount_rate` = 0 THEN 'No Discount'
        WHEN `discount_rate` <= 0.10 THEN '0% - 10%'
        WHEN `discount_rate` <= 0.20 THEN '10% - 20%'
        WHEN `discount_rate` <= 0.30 THEN '20% - 30%'
        ELSE '30%+'
    END AS discount_bucket,
    `discount_type`,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN `is_delivered` = 1 THEN 1 ELSE 0 END) AS delivered_orders,
    ROUND(AVG(`net_order_value`), 2) AS avg_net_order_value,
    ROUND(AVG(`gross_order_value`), 2) AS avg_gross_order_value,
    ROUND(AVG(`total_discount`), 2) AS avg_discount_amount,
    ROUND(SUM(`net_order_value`), 2) AS total_revenue,
    ROUND(AVG(`has_rating`), 4) AS rating_coverage_rate,
    ROUND(AVG(CASE WHEN `Rating` IS NOT NULL THEN `Rating` END), 2) AS avg_rating
FROM food_orders
GROUP BY
    CASE
        WHEN `discount_rate` = 0 THEN 'No Discount'
        WHEN `discount_rate` <= 0.10 THEN '0% - 10%'
        WHEN `discount_rate` <= 0.20 THEN '10% - 20%'
        WHEN `discount_rate` <= 0.30 THEN '20% - 30%'
        ELSE '30%+'
    END,
    `discount_type`
ORDER BY total_orders DESC, total_revenue DESC;