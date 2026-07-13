/*CREATE TABLE IF NOT EXISTS employee_satisfaction_survey(
	timestamp TIMESTAMP,
	email VARCHAR(30),
	stisfaction INT
);*/

/*ALTER TABLE employee_satisfaction_survey
RENAME COLUMN stisfaction TO satisfaction;
*/

SELECT *
FROM employee_satisfaction_survey;

--Solution
WITH latest_survey AS(
	SELECT *,
	CASE
		WHEN ROW_NUMBER() OVER(
			PARTITION BY email
			ORDER BY timestamp DESC
		) = 1 THEN 'last'
		ELSE 'old'
	END AS survey_order 
	FROM employee_satisfaction_survey
)
SELECT satisfaction, COUNT(email) 
FROM latest_survey
WHERE survey_order LIKE 'last'
GROUP BY satisfaction
ORDER BY satisfaction;

