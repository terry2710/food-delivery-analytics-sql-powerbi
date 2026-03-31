SELECT
    CASE
        WHEN `KPT_duration_minutes` < 15 THEN 'Fast Prep (<15m)'
        WHEN `KPT_duration_minutes` < 25 THEN 'Normal Prep (15-25m)'
        ELSE 'Slow Prep (25m+)'
    END AS prep_bucket,
    CASE
        WHEN `Rider_wait_time_minutes` < 5 THEN 'Low Wait (<5m)'
        WHEN `Rider_wait_time_minutes` < 10 THEN 'Medium Wait (5-10m)'
        ELSE 'High Wait (10m+)'
    END AS rider_wait_bucket,
    COUNT(*) AS delivered_orders,
    ROUND(AVG(CASE WHEN `Rating` IS NOT NULL THEN `Rating` END), 2) AS avg_rating,
    SUM(`has_review`) AS reviewed_orders,
    SUM(`has_complaint`) AS complaint_orders,
    ROUND(AVG(`has_complaint`), 4) AS complaint_rate,
    ROUND(AVG(`ready_marked_correct`), 4) AS ready_marked_correct_rate
FROM food_orders
WHERE `is_delivered` = 1
GROUP BY
    CASE
        WHEN `KPT_duration_minutes` < 15 THEN 'Fast Prep (<15m)'
        WHEN `KPT_duration_minutes` < 25 THEN 'Normal Prep (15-25m)'
        ELSE 'Slow Prep (25m+)'
    END,
    CASE
        WHEN `Rider_wait_time_minutes` < 5 THEN 'Low Wait (<5m)'
        WHEN `Rider_wait_time_minutes` < 10 THEN 'Medium Wait (5-10m)'
        ELSE 'High Wait (10m+)'
    END
ORDER BY complaint_rate DESC, avg_rating ASC;