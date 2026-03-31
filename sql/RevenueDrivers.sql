WITH daily_metrics AS (
    SELECT
        STR_TO_DATE(`order_date`, '%d/%m/%Y') AS order_dt,
        `order_weekday`,
        `is_weekend`,
        COUNT(DISTINCT `Order_ID`) AS delivered_orders,
        COUNT(DISTINCT `Customer_ID`) AS active_customers,
        SUM(`net_order_value`) AS revenue,
        AVG(`net_order_value`) AS aov
    FROM food_orders
    WHERE `is_delivered` = 1
    GROUP BY
        STR_TO_DATE(`order_date`, '%d/%m/%Y'),
        `order_weekday`,
        `is_weekend`
)
SELECT
    order_dt,
    order_weekday,
    is_weekend,
    delivered_orders,
    active_customers,
    ROUND(revenue, 2) AS revenue,
    ROUND(aov, 2) AS aov,
    ROUND(
        AVG(revenue) OVER (
            ORDER BY order_dt
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS rolling_7d_avg_revenue
FROM daily_metrics
ORDER BY order_dt;