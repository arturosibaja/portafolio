## E-commerce Analytics Case

## Business Problem
Analyze user behavior across the purchase funnel, product-level conversion, and customer retention to identify performance gaps and improvement opportunities.

## Dataset
Simulated e-commerce dataset including events, orders, products, and users.
https://www.kaggle.com/datasets/wafaaelhusseini/e-commerce-transactions-clickstream/data?select=sessions.csv

## Analysis Performed (SQL and Power BI)
- Funnel analysis using SQL to identify drop-off points
- Product-level conversion analysis for selected SKUs
- Retention rate with cohorts in SQL
- Dashboards in Power BI to visualize these information.

## Key Insights
- Identified major drop-off between product view and add-to-cart. Only 26.7%.
- Selected SKU shows strong views but low conversion, indicating potential pricing or UX issues
- Retention analysis highlights low repeat purchase after first order

## Outputs
- SQL scripts for funnel and retention analysis
  -Funnel_product.sql = SQL query
  -Funnel_product_data.csv = SQL query result
  -retention_rate.sql = SQL query
  -retention_rate_data.csv = SQL query result
- Power BI dashboard visualizing funnel, conversion, and retention KPIs
  -Funnel_Dashboard.png = Power BI screenshot of the funnel sql result with graphs
