-- DROP TABLE IF EXISTS inpatient_admissions;

/*CREATE TABLE inpatient_admissions (
    admission_id VARCHAR(8),
    patient_id VARCHAR(5),
    admission_date DATE,
    discharge_date DATE
);*/


SELECT *
FROM inpatient_admissions;

WITH readmissions AS(
	SELECT 
	(
		LEAD(admission_date) OVER(
			PARTITION BY patient_id ORDER BY admission_date
		) 
		- discharge_date
	) AS readmission_days
	FROM inpatient_admissions
),
readmissions_30_days AS (
	SELECT *
	FROM readmissions
	WHERE readmission_days <=30
)
SELECT
	(
	    (SELECT COUNT(*) FROM readmissions_30_days)::"numeric"
	    /
	    (SELECT COUNT(*) FROM readmissions) 
	 	* 100  
	 ) AS readmission_rate;



WITH readmissions AS (
    SELECT
        LEAD(admission_date) OVER (
            PARTITION BY patient_id
            ORDER BY admission_date
        ) - discharge_date AS readmission_days
    FROM inpatient_admissions
)
SELECT
    COUNT(*) FILTER (WHERE readmission_days <= 30)::numeric
    / COUNT(*) * 100 AS readmission_rate
FROM readmissions;
