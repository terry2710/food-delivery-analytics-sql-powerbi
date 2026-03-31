SELECT
    `Restaurant_name`,
    COUNT(`Order_ID`) AS total_orders,
    SUM(CASE WHEN `is_delivered` = 1 THEN 1 ELSE 0 END) AS delivered_orders,
    SUM(CASE WHEN `is_failed` = 1 THEN 1 ELSE 0 END) AS failed_orders,
    ROUND(
        SUM(CASE WHEN `is_failed` = 1 THEN 1 ELSE 0 END) / COUNT(`Order_ID`),
        4
    ) AS failure_rate,
    ROUND(AVG(`KPT_duration_minutes`), 2) AS avg_kpt_minutes,
    ROUND(AVG(`Rider_wait_time_minutes`), 2) AS avg_rider_wait_minutes
FROM food_orders
GROUP BY `Restaurant_name`
HAVING COUNT(`Order_ID`) >= 30
ORDER BY failure_rate DESC, failed_orders DESC;