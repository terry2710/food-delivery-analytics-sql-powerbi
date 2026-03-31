WITH first_order AS (
    SELECT
        `Customer_ID`,
        MIN(STR_TO_DATE(`order_date`, '%d/%m/%Y')) AS first_order_date
    FROM food_orders
    WHERE `is_delivered` = 1
    GROUP BY `Customer_ID`
),
user_activity AS (
    SELECT
        f.`Customer_ID`,
        f.first_order_date,
        STR_TO_DATE(o.`order_date`, '%d/%m/%Y') AS activity_date,
        DATEDIFF(
            STR_TO_DATE(o.`order_date`, '%d/%m/%Y'),
            f.first_order_date
        ) AS days_since_first
    FROM food_orders o
    JOIN first_order f
        ON o.`Customer_ID` = f.`Customer_ID`
    WHERE o.`is_delivered` = 1
),
cohort_size AS (
    SELECT
        first_order_date,
        COUNT(DISTINCT `Customer_ID`) AS cohort_users
    FROM first_order
    GROUP BY first_order_date
),
retention AS (
    SELECT
        first_order_date,
        days_since_first,
        COUNT(DISTINCT `Customer_ID`) AS retained_users
    FROM user_activity
    GROUP BY first_order_date, days_since_first
)
SELECT
    r.first_order_date,
    r.days_since_first,
    r.retained_users,
    c.cohort_users,
    ROUND(r.retained_users / c.cohort_users, 4) AS retention_rate
FROM retention r
JOIN cohort_size c
    ON r.first_order_date = c.first_order_date
WHERE r.days_since_first IN (0, 1, 7, 14, 30)
ORDER BY r.first_order_date, r.days_since_first;