/*CREATE TABLE IF NOT EXISTS marathon_data(
	age INT,
	gender VARCHAR(1),
	split TIME,
	final TIME
)*/

SELECT *
FROM marathon_data
LIMIT 10;

WITH bands AS (
SELECT *,
CASE
	WHEN final < '03:00:00' THEN  'Sub 3:00'
	WHEN final < '03:30:00'  THEN  '3:00 - 3:30'
	WHEN final < '04:00:00'  THEN  '3:30 - 4:00'
	WHEN final < '04:30:00'  THEN  '4:00 - 4:30'
	WHEN final < '05:00:00'  THEN  '4:30 - 5:00'
	WHEN final < '05:30:00'  THEN  '5:00 - 5:30'
	WHEN final < '06:00:00'  THEN  '5:30 - 6:00'
	ELSE '6:00+'
	END AS finish_band
FROM marathon_data)
SELECT 
	finish_band,
	ROUND((
		COUNT(*)/
		SUM(COUNT(*)) OVER()
	) * 100, 2) AS "% of Field"
FROM bands
GROUP BY finish_band
ORDER BY
	CASE finish_band
        WHEN 'Sub 3:00' THEN 1
        WHEN '3:00 - 3:30' THEN 2
        WHEN '3:30 - 4:00' THEN 3
        WHEN '4:00 - 4:30' THEN 4
        WHEN '4:30 - 5:00' THEN 5
        WHEN '5:00 - 5:30' THEN 6
        WHEN '5:30 - 6:00' THEN 7
        WHEN '6:00+' THEN 8
    END;
