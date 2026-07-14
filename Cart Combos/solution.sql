/*CREATE TABLE IF NOT EXISTS grocery_transactions(
	transaction_id INT,
	transaction_datetime TIMESTAMP,
	register INT,
	line_item INT,
	upc VARCHAR(12),
	product_name VARCHAR(25),
	quantity INT,
	unit_price FLOAT
);*/

SELECT *
FROM grocery_transactions
LIMIT 10;

SELECT 
	gt1.product_name, 
	gt2.product_name, 
	COUNT(gt1.transaction_id) AS total_transactions
FROM grocery_transactions AS gt1
	JOIN grocery_transactions as gt2
	ON gt1.transaction_id = gt2.transaction_id
	AND gt1.product_name < gt2.product_name
GROUP BY gt1.product_name, gt2.product_name
ORDER BY total_transactions DESC;


