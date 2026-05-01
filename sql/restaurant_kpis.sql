-- Restaurant KPI Dashboard Queries
-- Lagos delivery platform analytics

-- 1. Daily order volume and revenue trend
SELECT
    DATE_TRUNC('day', order_time) AS order_date,
    COUNT(order_id) AS total_orders,
    SUM(order_value) AS gross_revenue,
    AVG(order_value) AS avg_basket_size,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM orders
WHERE restaurant_id = :restaurant_id
  AND order_time >= CURRENT_DATE - INTERVAL '90 days'
  AND status = 'DELIVERED'
GROUP BY 1
ORDER BY 1;

-- 2. Menu item performance (engineering matrix)
SELECT
    m.item_name,
    m.category,
    m.price,
    m.cost_price,
    ROUND((m.price - m.cost_price) / m.price * 100, 1) AS margin_pct,
    COUNT(oi.order_id) AS units_sold,
    SUM(oi.quantity * m.price) AS total_revenue,
    ROUND(COUNT(oi.order_id) * 100.0 / SUM(COUNT(oi.order_id)) OVER (), 2) AS order_share_pct,
    CASE
        WHEN COUNT(oi.order_id) > AVG(COUNT(oi.order_id)) OVER ()
         AND (m.price - m.cost_price) > AVG(m.price - m.cost_price) OVER () THEN 'STAR'
        WHEN COUNT(oi.order_id) > AVG(COUNT(oi.order_id)) OVER ()
         AND (m.price - m.cost_price) <= AVG(m.price - m.cost_price) OVER () THEN 'PLOWHOUSE'
        WHEN COUNT(oi.order_id) <= AVG(COUNT(oi.order_id)) OVER ()
         AND (m.price - m.cost_price) > AVG(m.price - m.cost_price) OVER () THEN 'PUZZLE'
        ELSE 'DOG'
    END AS menu_classification
FROM order_items oi
JOIN menu_items m ON oi.item_id = m.item_id
WHERE oi.restaurant_id = :restaurant_id
GROUP BY m.item_name, m.category, m.price, m.cost_price
ORDER BY total_revenue DESC;

-- 3. Hourly order heatmap (peak hours analysis)
SELECT
    EXTRACT(DOW FROM order_time) AS day_of_week,   -- 0=Sunday
    EXTRACT(HOUR FROM order_time) AS hour_of_day,
    COUNT(order_id) AS order_count,
    AVG(order_value) AS avg_basket
FROM orders
WHERE restaurant_id = :restaurant_id
  AND status = 'DELIVERED'
GROUP BY 1, 2
ORDER BY 1, 2;

-- 4. Customer retention & reorder rate
WITH first_orders AS (
    SELECT customer_id, MIN(order_time) AS first_order_date
    FROM orders WHERE restaurant_id = :restaurant_id
    GROUP BY customer_id
),
returning AS (
    SELECT o.customer_id
    FROM orders o
    JOIN first_orders f ON o.customer_id = f.customer_id
    WHERE o.order_time > f.first_order_date
      AND o.restaurant_id = :restaurant_id
)
SELECT
    COUNT(DISTINCT f.customer_id) AS total_customers,
    COUNT(DISTINCT r.customer_id) AS returning_customers,
    ROUND(COUNT(DISTINCT r.customer_id) * 100.0 / COUNT(DISTINCT f.customer_id), 1) AS reorder_rate_pct
FROM first_orders f
LEFT JOIN returning r ON f.customer_id = r.customer_id;

-- 5. Delivery zone performance (Lagos neighbourhoods)
SELECT
    delivery_zone,
    COUNT(order_id) AS total_orders,
    SUM(order_value) AS zone_revenue,
    AVG(delivery_time_mins) AS avg_delivery_mins,
    AVG(customer_rating) AS avg_rating
FROM orders
WHERE restaurant_id = :restaurant_id
  AND status = 'DELIVERED'
GROUP BY delivery_zone
ORDER BY total_orders DESC;
