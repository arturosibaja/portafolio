
-- This query benchmarks webcam products by comparing each item’s price and percentage margin 
-- against the average price and margin of the category, helping identify potential overpricing 
-- and margin optimization opportunities for low-conversion products.

SELECT 
	*,
    ROUND(((price_usd - cost_usd)/price_usd)*100,2) as pct_margin, -- Margin formula = (price-cost) / price
    (
    SELECT ROUND(AVG(price_usd),2)               -- Subquery webcam avg price
    FROM products as avg_price
	WHERE name like "%webcam%"
    ) AS avg_webcam_price,
	(
    SELECT  ROUND(AVG(((price_usd - cost_usd)/price_usd)*100),2)  -- Subquery webcam avg margin
    FROM products as avg_margin_pct
	WHERE name like "%webcam%"
    ) AS avg_webcam_price	
FROM products
WHERE name LIKE "%webcam%";