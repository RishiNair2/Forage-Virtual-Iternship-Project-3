---Transaction Data Queries ----
SELECT *
FROM transaction_data;

--- Month with the most transactions---
SELECT EXTRACT('month' FROM date) transaction_month, COUNT(transaction_id) num_transactions
FROM transaction_data
GROUP BY transaction_month
ORDER BY num_transactions DESC;

--- Packsize that was bougth the most---
SELECT package_size, COUNT(transaction_id) num_transactions
FROM transaction_data
GROUP BY package_size
ORDER BY num_transactions DESC;

--- Most popular brand based on transactions---
SELECT brand_name, COUNT(transaction_id) num_transactions
FROM transaction_data
GROUP BY brand_name
ORDER BY num_transactions DESC;

--- Store that generated the most revenue---
SELECT store_number, SUM(total_sales) sales_revenue
FROM transaction_data
WHERE store_number IS NOT NULL
GROUP BY store_number
ORDER BY sales_revenue DESC;

--- Month with the most revenue---
SELECT EXTRACT('month' FROM date) transaction_month, SUM(total_sales) sales_revenue
FROM transaction_data
WHERE EXTRACT('month' FROM date) IS NOT NULL
GROUP BY transaction_month
ORDER BY sales_revenue DESC;

---Average revenue by month---
SELECT EXTRACT('month' FROM date) transaction_month, AVG(total_sales) avg_sales_revenue
FROM transaction_data
WHERE EXTRACT('month' FROM date) IS NOT NULL
GROUP BY transaction_month
ORDER BY sales_revenue DESC;

---Year with the most revenue---
SELECT EXTRACT('year' FROM date) transaction_year, SUM(total_sales) sales_revenue
FROM transaction_data
WHERE EXTRACT('year' FROM date) IS NOT NULL
GROUP BY transaction_year
ORDER BY sales_revenue DESC;

---Brand Name with the most revenue---
SELECT brand_name, SUM(total_sales) sales_revenue
FROM transaction_data
WHERE brand_name IS NOT NULL
GROUP BY brand_name
ORDER BY sales_revenue DESC;

--- Product with the most in stock---
SELECT product_name, SUM(product_quantity) total_quantity
FROM transaction_data
WHERE product_name IS NOT NULL
GROUP BY product_name
ORDER BY total_quantity DESC;

---Average product quantity by brand name ---
SELECT brand_name, AVG(product_quantity) avg_quantity
FROM transaction_data
WHERE brand_name IS NOT NULL
GROUP BY brand_name
ORDER BY avg_quantity DESC;

--- Package Size Category With The Most Sales---
SELECT CASE WHEN package_size < 134 THEN 'Small'
WHEN package_size BETWEEN 135 AND 170 THEN 'Medium'
WHEN package_size BETWEEN 175 AND 210 THEN 'Large'
WHEN package_size BETWEEN 220 AND 380 THEN 'X-Large' END AS package_category,
SUM(total_sales) sales_revenue
FROM transaction_data
GROUP BY package_category
ORDER BY sales_revenue DESC;

--- Number of transactions by month on a rolling basis---
SELECT EXTRACT('month' FROM date) month_date,transaction_id, COUNT(transaction_id) OVER(PARTITION BY EXTRACT('month' FROM date))
FROM transaction_data

---- Total revenue by month on a rolling basis---
SELECT store_number, product_name, EXTRACT('month' FROM date) month_date, total_sales,
SUM(total_sales) OVER (PARTITION BY EXTRACT('month' FROM date))
FROM transaction_data