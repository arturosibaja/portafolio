
-- Comparar si el producto 59 está por encima del precio promedio
-- Ver webcams como los ID 142 y 101 con mejor conversion_rate que precio tienen

SELECT 
	*,
    ROUND(((price_usd - cost_usd)/price_usd)*100,2) as pct_margin,
    (
    SELECT ROUND(AVG(price_usd),2) 
    FROM products as avg_price
	WHERE name like "%webcam%"
    ) AS avg_webcam_price
 FROM products
WHERE name LIKE "%webcam%";