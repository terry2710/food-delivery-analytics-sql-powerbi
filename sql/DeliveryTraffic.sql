WITH subzone_hourly AS (
    SELECT
        `Subzone`,
        `order_hour`,
        COUNT(`Order_ID`) AS hourly_orders
    FROM food_orders
    WHERE `is_delivered` = 1
    GROUP BY `Subzone`, `order_hour`
),
subzone_peak AS (
    SELECT
        `Subzone`,
        `order_hour` AS peak_hour,
        hourly_orders AS peak_hour_orders
    FROM (
        SELECT
            `Subzone`,
            `order_hour`,
            hourly_orders,
            ROW_NUMBER() OVER (
                PARTITION BY `Subzone`
                ORDER BY hourly_orders DESC
            ) AS rn
        FROM subzone_hourly
    ) t
    WHERE rn = 1
)
SELECT
    f.`Subzone`,
    COUNT(f.`Order_ID`) AS delivered_orders,
    COUNT(DISTINCT f.`Restaurant_name`) AS restaurant_count,
    ROUND(
        COUNT(f.`Order_ID`) / COUNT(DISTINCT f.`Restaurant_name`),
        2
    ) AS avg_orders_per_restaurant,
    COUNT(DISTINCT STR_TO_DATE(f.`order_date`, '%d/%m/%Y')) AS active_days,
    ROUND(
        COUNT(f.`Order_ID`) / COUNT(DISTINCT STR_TO_DATE(f.`order_date`, '%d/%m/%Y')),
        2
    ) AS avg_daily_orders,
    sp.peak_hour_orders,
    sp.peak_hour,
    ROUND(AVG(f.`distance_km`), 2) AS avg_distance_km,
    ROUND(AVG(f.`KPT_duration_minutes`), 2) AS avg_kpt_minutes,
    ROUND(AVG(f.`Rider_wait_time_minutes`), 2) AS avg_rider_wait_minutes
FROM food_orders f
LEFT JOIN subzone_peak sp
    ON f.`Subzone` = sp.`Subzone`
WHERE f.`is_delivered` = 1
GROUP BY
    f.`Subzone`,
    sp.peak_hour_orders,
    sp.peak_hour
ORDER BY avg_daily_orders DESC, peak_hour_orders DESC;