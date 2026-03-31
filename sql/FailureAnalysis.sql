SELECT
    `order_status_clean`,
    `Cancellation__Rejection_reason` AS failure_reason,
    `Restaurant_name`,
    `City`,
    `order_weekday`,
    `order_hour`,
    COUNT(*) AS failed_orders,
    ROUND(SUM(COALESCE(`Restaurant_compensation_Cancellation`, 0)), 2) AS total_compensation,
    ROUND(SUM(COALESCE(`Restaurant_penalty_Rejection`, 0)), 2) AS total_penalty,
    ROUND(AVG(`distance_km`), 2) AS avg_distance_km,
    ROUND(AVG(`KPT_duration_minutes`), 2) AS avg_kpt_minutes,
    ROUND(AVG(`Rider_wait_time_minutes`), 2) AS avg_rider_wait_minutes
FROM food_orders
WHERE `is_failed` = 1
GROUP BY
    `order_status_clean`,
    `Cancellation__Rejection_reason`,
    `Restaurant_name`,
    `City`,
    `order_weekday`,
    `order_hour`
ORDER BY failed_orders DESC, total_compensation DESC, total_penalty DESC;