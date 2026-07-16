/*CREATE TABLE IF NOT EXISTS baseball_positions(
	name VARCHAR(28),
	team VARCHAR(19),
	position VARCHAR(14)
);
*/

WITH explode_position AS (
	SELECT *
	FROM baseball_positions
	CROSS JOIN LATERAL UNNEST(STRING_TO_ARRAY(position,'/')) AS positions
)
SELECT positions, COUNT(*) AS number_of_players
FROM explode_position
GROUP BY positions
ORDER BY COUNT(*) DESC;



