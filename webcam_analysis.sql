-- Analizar el conversion_rate de las webcams

WITH

product_viewers AS (
	SELECT 
		e.product_id,
        COUNT(DISTINCT s.customer_id) AS viewers
	FROM events e
	JOIN sessions s
    USING (session_id)
    WHERE event_type = "page_view"
    GROUP BY 1
    
),

product_buyers AS (
	SELECT 
		oi.product_id,
        COUNT(DISTINCT o.customer_id) AS buyers
	FROM order_items oi
    JOIN orders o 
    ON oi.order_id = o.order_id
    GROUP BY 1

)

SELECT 
	pv.product_id,
    p.name,
    pv.viewers,
    COALESCE(pb.buyers,0) AS buyers,
    ROUND((COALESCE(pb.buyers,0) / pv.viewers) * 100,2) as conversion_rate
FROM product_viewers pv
LEFT JOIN product_buyers pb
ON pv.product_id = pb.product_id
LEFT JOIN products p
ON pv.product_id = p.product_id
WHERE NAME LIKE "%webcam%"
ORDER BY 4 asc, 2 desc;