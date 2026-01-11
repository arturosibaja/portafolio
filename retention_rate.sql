WITH
first_purchase AS(   -- Da la fecha de la primer compra de cada cliente

SELECT
	customer_id,
    MIN(STR_TO_DATE(order_time, "%Y-%m-%dT%H:%i:%s")) as first_purchase_date
FROM orders
GROUP BY 1
),
orders_with_cohort AS (     -- Cambia formato a año-mes y crea columna para meses despues de 1er compra
SELECT
	o.customer_id,
    DATE_FORMAT(fp.first_purchase_date, "%Y-%m") AS cohort_month,
    TIMESTAMPDIFF(
    MONTH,
    fp.first_purchase_date,
    o.order_time
    ) AS months_after_first_purchase
FROM orders o
JOIN first_purchase fp
USING (customer_id)
),
cohort_active_customers AS (  -- Hace el conteo de cantidad de compradores por cohorte y por cada mes posterior
SELECT 
	cohort_month,
    months_after_first_purchase,
    COUNT(DISTINCT customer_id) AS active_customers
FROM orders_with_cohort
GROUP BY 1,2
),
cohort_size AS(   -- Devuelve el primer valor de cada cohorte, para tener de referencia el total de usuarios con los que inició la cohorte
SELECT 
cohort_month,
active_customers AS cohort_size
FROM cohort_active_customers
WHERE months_after_first_purchase = 0
)

SELECT                       -- Query final
	ca.cohort_month,
    ca.months_after_first_purchase,
    ca.active_customers,
    cs.cohort_size,
	ROUND(                                            -- operacion de retention_rate
    (ca.active_customers / cs.cohort_size)*100,2
    ) AS retention_rate
FROM cohort_active_customers ca
JOIN cohort_size cs
USING (cohort_month)
WHERE months_after_first_purchase BETWEEN 0 AND 12
ORDER BY 1,2;