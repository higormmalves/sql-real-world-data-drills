/*CREATE TABLE IF NOT EXISTS property_sales(
	neighborhood VARCHAR(18),
	address VARCHAR(22),
	zip_code VARCHAR(5),
	building_class VARCHAR(2),
	square_feet FLOAT,
	sale_price FLOAT
);
*/

SELECT *
FROM property_sales
WHERE zip_code = '10011';

--Solution
WITH price_per_zip AS (
	SELECT 
		zip_code,
		building_class,
		AVG(sale_price/square_feet) AS average_price
	FROM property_sales
	WHERE sale_price > 0
	GROUP BY zip_code, building_class
),
new_market_value AS(
	SELECT 
		*,
		CASE
			WHEN ps.sale_price = 0 THEN ROUND((ps.square_feet*ppz.average_price)::numeric, 1)
			ELSE ps.sale_price
		END AS market_value
	FROM property_sales ps
	LEFT JOIN price_per_zip ppz
	ON ps.zip_code = ppz.zip_code
	AND ps.building_class = ppz.building_class
)
SELECT COUNT(*)
FROM new_market_value
WHERE market_value >= 15000000;

