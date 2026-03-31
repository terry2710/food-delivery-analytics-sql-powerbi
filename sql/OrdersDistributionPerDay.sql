SELECT
    order_hour,
    CASE
        WHEN is_weekend = 1 THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    COUNT(`Order_ID`) AS delivered_orders_hourly
FROM food_orders
WHERE `is_delivered` = 1
GROUP BY
    order_hour,
    CASE
        WHEN is_weekend = 1 THEN 'Weekend'
        ELSE 'Weekday'
    END
ORDER BY
    order_hour,
    day_type;