--- Puchase Behavior Queries ---
SELECT *
FROM purchase_behavior;

--- Most type of customers ---
SELECT customer_type, COUNT(loyalty_card_number) num_customers
FROM purchase_behavior
GROUP BY customer_type 
ORDER BY num_customers DESC;

--- Most customers by lifestage ---
SELECT lifestage, COUNT(loyalty_card_number) num_customers
FROM purchase_behavior
GROUP BY lifestage
ORDER BY num_customers DESC;

--- Proportion Of Each Customer Type to the overall customer base---
SELECT customer_type, COUNT(loyalty_card_number) *100/(SELECT SUM(t1.total_customers) FROM (SELECT customer_type, COUNT(loyalty_card_number) total_customers
														FROM purchase_behavior
														GROUP BY customer_type
														ORDER BY COUNT(loyalty_card_number) DESC
														LIMIT 5) t1) percent_of_total
FROM purchase_behavior
GROUP BY customer_type
ORDER BY percent_of_total DESC
LIMIT 5;

---Proportion Of Each Lifestage to the overall customer base---
SELECT lifestage, COUNT(loyalty_card_number) *100/(SELECT SUM(t1.total_customers) FROM (SELECT lifestage, COUNT(loyalty_card_number) total_customers
													FROM purchase_behavior
													GROUP BY lifestage
													ORDER BY COUNT(loyalty_card_number) DESC
													) t1) percent_of_total
FROM purchase_behavior
GROUP BY lifestage
ORDER BY percent_of_total DESC;

---- Proportion of Customers by Lifestage and Premium Customer----
SELECT lifestage, customer_type, COUNT(loyalty_card_number) *100/(SELECT SUM(t1.total_customers) FROM ( SELECT lifestage, customer_type, COUNT(loyalty_card_number) total_customers
													FROM purchase_behavior
													GROUP BY lifestage, customer_type
													ORDER BY COUNT(loyalty_card_number) DESC
													) t1) percent_of_total
FROM purchase_behavior
GROUP BY lifestage, customer_type
ORDER BY percent_of_total DESC;
