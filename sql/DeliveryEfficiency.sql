SELECT
    CASE
        WHEN `distance_km` < 1 THEN '<1 km'
        WHEN `distance_km` < 3 THEN '1-3 km'
        WHEN `distance_km` < 5 THEN '3-5 km'
        ELSE '5+ km'
    END AS distance_bucket,
    COUNT(*) AS total_orders,
    ROUND(AVG(`KPT_duration_minutes`), 2) AS avg_kpt_minutes,
    ROUND(AVG(`Rider_wait_time_minutes`), 2) AS avg_rider_wait_minutes,
    ROUND(AVG(CASE WHEN `ready_marked_correct` = 1 THEN 1 ELSE 0 END), 4) AS ready_marked_correct_rate,
    ROUND(AVG(CASE WHEN `Rating` IS NOT NULL THEN `Rating` END), 2) AS avg_rating,
    ROUND(AVG(`net_order_value`), 2) AS avg_order_value
FROM food_orders
WHERE `is_delivered` = 1
GROUP BY
    CASE
        WHEN `distance_km` < 1 THEN '<1 km'
        WHEN `distance_km` < 3 THEN '1-3 km'
        WHEN `distance_km` < 5 THEN '3-5 km'
        ELSE '5+ km'
    END
ORDER BY
    CASE
        WHEN distance_bucket = '<1 km' THEN 1
        WHEN distance_bucket = '1-3 km' THEN 2
        WHEN distance_bucket = '3-5 km' THEN 3
        ELSE 4
    END;