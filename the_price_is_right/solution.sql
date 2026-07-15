/*
CREATE TABLE IF NOT EXISTS price_history(
	pizza_id  INT,
 	effective_date DATE, 
 	price FLOAT
);

CREATE TABLE IF NOT EXISTS products(
	pizza_id  INT,
 	name VARCHAR(15), 
 	current_price FLOAT
);

CREATE TABLE IF NOT EXISTS transactions(
	order_detail_id  INT,
	order_id INT,
	order_date DATE,
	pizza_id  INT,
 	quantity INT
);
*/

SELECT *
FROM price_history
WHERE pizza_id = 1;

SELECT *
FROM products
WHERE pizza_id = 2;

SELECT *
FROM transactions
WHERE pizza_id = 1;

--Solution
WITH most_recent_date AS(
	SELECT
		t.order_detail_id,
		t.order_date,
		t.pizza_id,
		t.quantity,
		MAX(ph.effective_date) AS most_recent_date
	FROM transactions t
	LEFT JOIN price_history ph
	ON t.pizza_id = ph.pizza_id
	AND t.order_date >= ph.effective_date
	GROUP BY 1, 2, 3, 4
),
full_transaction_data AS (
	SELECT 
		mrd.*,
		ph.price
	FROM most_recent_date mrd
	LEFT JOIN price_history ph
	ON mrd.pizza_id = ph.pizza_id
	AND mrd.most_recent_date = ph.effective_date
	ORDER BY mrd.order_detail_id
)
SELECT SUM(quantity*price) AS total_revenue
FROM full_transaction_data;