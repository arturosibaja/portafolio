-- This query builds a product-level conversion funnel by tracking unique customers who
-- viewed a product, added it to cart, and completed a purchase. 
-- It calculates view-to-cart, cart-to-purchase, and overall view-to-purchase conversion rates, 
-- filtering products with sufficient traffic for reliable analysis.

WITH product_viewers AS ( 
  SELECT DISTINCT
    e.product_id,
    s.customer_id
  FROM events e
	JOIN sessions s
  USING (session_id)
  WHERE event_type = 'page_view'
    AND s.customer_id IS NOT NULL
    AND e.product_id IS NOT NULL
),
product_carts AS (     
  SELECT DISTINCT
    e.product_id,
    s.customer_id
  FROM events e
    JOIN sessions s
  USING (session_id)
  WHERE event_type = 'add_to_cart'
    AND s.customer_id IS NOT NULL
    AND e.product_id IS NOT NULL
),
product_buyers AS (        
  SELECT DISTINCT          
    oi.product_id,
    o.customer_id
  FROM order_items oi
  JOIN orders o
    ON o.order_id = oi.order_id
  WHERE oi.product_id IS NOT NULL
    AND o.customer_id IS NOT NULL
),
funnel_by_product AS (     
  SELECT                    
    pv.product_id,
    pv.customer_id,
    1 AS did_view,
    CASE WHEN pc.customer_id IS NOT NULL THEN 1 ELSE 0 END AS did_cart,
    CASE WHEN pb.customer_id IS NOT NULL THEN 1 ELSE 0 END AS did_purchase
  FROM product_viewers pv
  LEFT JOIN product_carts pc
    ON pc.product_id = pv.product_id
   AND pc.customer_id = pv.customer_id
  LEFT JOIN product_buyers pb
    ON pb.product_id = pv.product_id
   AND pb.customer_id = pv.customer_id
)
SELECT          
  product_id,   
  COUNT(*) AS viewers,                  
  SUM(did_cart) AS add_to_cart_users,    
  SUM(did_purchase) AS purchasers,
  ROUND(SUM(did_cart) / NULLIF(COUNT(*), 0) * 100, 2) AS view_to_cart_rate,      
  ROUND(SUM(did_purchase) / NULLIF(SUM(did_cart), 0) * 100, 2) AS cart_to_purchase_rate,
  ROUND(SUM(did_purchase) / NULLIF(COUNT(*), 0) * 100, 2) AS view_to_purchase_rate
FROM funnel_by_product
GROUP BY product_id
HAVING viewers >= 100
ORDER BY view_to_purchase_rate ASC, viewers DESC;
