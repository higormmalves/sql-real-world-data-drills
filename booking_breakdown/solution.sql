/*
CREATE TABLE IF NOT EXISTS hotel_bookings(
	booking_id INT,	
	booking_date DATE,
	cancel_date DATE,
	checkin_date DATE,
	checkout_date DATE,
	is_canceled BOOL
);
*/

SELECT MIN(checkin_date), MAX(checkout_date)
FROM hotel_bookings;

--Min="2015-07-01"	
--Max="2017-09-14"

WITH RECURSIVE calendar AS (
	--Membro âncora
	SELECT '2015-07-01'::date AS available_dates
	UNION ALL
	--Membro recursivo
	SELECT available_dates + 1
	FROM calendar
	WHERE available_dates < '2017-09-30'::date
),
daily_occupancy AS (
	SELECT
		c.available_dates,
		COUNT(hb.booking_id) AS nights_occupied
	FROM 
		calendar c
		LEFT JOIN hotel_bookings hb
		ON c.available_dates BETWEEN hb.checkin_date AND hb.checkout_date - 1
		AND hb.is_canceled = FALSE
	GROUP BY c.available_dates
)
SELECT 
	TO_CHAR(available_dates, 'yy-MM-01') AS month_start,
	SUM(nights_occupied) AS total_nights_occupied,
	(COUNT(*) * 200) AS total_available,
	ROUND((SUM(nights_occupied)/(COUNT(*) * 200))*100, 1) AS pct_occupancy_rate
FROM daily_occupancy
GROUP BY 1
ORDER BY 1;
	