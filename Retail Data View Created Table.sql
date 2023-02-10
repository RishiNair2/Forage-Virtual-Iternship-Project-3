--- Retail Data View Created Table ---
CREATE VIEW grocery_data AS(
	SELECT p.loyalty_card_number, p.lifestage, p.customer_type, d.date, d.store_number,
	d.transaction_id, d.product_number, d.brand_name, d.product_name, d.package_size, 
	d.product_quantity, d.total_sales
	FROM purchase_behavior p
	JOIN transaction_data d
	ON p.loyalty_card_number = d.loyalty_card_number
)
--- Grocery Data Initial Query---
SELECT *
FROM grocery_data;

---- Average Package Size with each customer type---
SELECT customer_type, AVG(package_size) avg_package_size
FROM grocery_data
GROUP BY customer_type
ORDER BY avg_package_size DESC;

---- Determining the product preference for each customer type ---
SELECT customer_type, product_name, COUNT(product_name) product_type_num
FROM grocery_data
GROUP BY customer_type, product_name
ORDER BY product_type_num DESC;

--- Total sales by LIFESTAGE and PREMIUM_CUSTOMER to describe which customer segment contribute most to chip sales---
SELECT lifestage, customer_type, SUM(total_sales) total_revenue
FROM grocery_data
GROUP BY lifestage, customer_type;

--- Total proportion of sales by LIFESTAGE and PREMIUM_CUSTOMER to describe which customer segment contribute most to chip sales---
SELECT lifestage,customer_type, SUM(total_sales) *100/(SELECT SUM(t1.total_revenue)
													FROM (
													SELECT lifestage, customer_type, SUM(total_sales) total_revenue
													FROM grocery_data
													GROUP BY lifestage, customer_type
													) t1) percent_of_total	
FROM grocery_data
GROUP BY lifestage, customer_type;

--- Determining if Higher sales may also be driven by more units of chips being bought per customer---
SELECT customer_type, lifestage, AVG(t1.num_units)
FROM(
SELECT customer_type, lifestage, SUM(product_quantity)/COUNT(DISTINCT loyalty_card_number) num_units
FROM grocery_data
GROUP BY customer_type, lifestage) t1
GROUP BY customer_type, lifestage;

--- Average price per unit chips bought for each customer segment---
SELECT customer_type, lifestage, AVG(t1.avg_sales)
FROM(
SELECT customer_type, lifestage, SUM(total_sales)/SUM(product_quantity) avg_sales
FROM grocery_data
GROUP BY customer_type, lifestage) t1
GROUP BY customer_type, lifestage;
---- Brand affinity for YOUNG SINGLES/COUPLES and Mainstream----
SELECT brand_name, SUM(product_quantity)/(SELECT SUM(t1.total_quantity)
													FROM (
													SELECT brand_name, SUM(product_quantity) total_quantity
													FROM grocery_data
													WHERE customer_type = 'Mainstream' AND lifestage = 'YOUNG SINGLES/COUPLES'
													GROUP BY brand_name	
													)t1) percent_of_total
FROM grocery_data
GROUP BY brand_name;
----- Brand affinity compared to the rest of the population
SELECT brand_name, SUM(product_quantity)/(SELECT SUM(t1.total_quantity)
													FROM (
													SELECT brand_name, SUM(product_quantity) total_quantity
													FROM grocery_data
													WHERE customer_type != 'Mainstream' AND lifestage != 'YOUNG SINGLES/COUPLES'
													GROUP BY brand_name	
													)t1) percent_of_total
FROM grocery_data
GROUP BY brand_name;

--- Number of transactions made by lifestage and customer type ---
SELECT customer_type, lifestage, COUNT(transaction_id) transactions
FROM grocery_data
GROUP BY customer_type, lifestage
ORDER BY transactions DESC;

--- The month and year where each customer type and lifestage spent the most money---
SELECT customer_type, lifestage, EXTRACT('month' FROM date) month_date,
SUM(total_sales) total_revenue
FROM grocery_data
GROUP BY customer_type, lifestage, month_date
ORDER BY total_revenue DESC;

SELECT customer_type, lifestage, EXTRACT('year' FROM date) month_date,
SUM(total_sales) total_revenue
FROM grocery_data
GROUP BY customer_type, lifestage, month_date
ORDER BY total_revenue DESC;

--- Dropping The View---
DROP VIEW grocery_data;