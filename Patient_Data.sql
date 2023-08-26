-- Patients in Healthcare Data
-- Why we look at who our patients are? 
	SELECT 
    GENDER, COUNT(*)
FROM
    HEALTHCARE.patients
GROUP BY GENDER;
    
SELECT 
    RACE, COUNT(*)
FROM
    HEALTHCARE.patients
GROUP BY RACE;
    
SELECT 
    ethnicity, COUNT(*)
FROM
    HEALTHCARE.patients
GROUP BY ETHNICITY;

SELECT 
    GENDER, RACE, ETHNICITY, COUNT(*)
FROM
    HEALTHCARE.patients
GROUP BY GENDER , RACE , ETHNICITY;

    -- What about age? 
SELECT 
    ID,
    BIRTHDATE,
    FLOOR(DATEDIFF(CURDATE(), BIRTHDATE) / 365.25) AS AGE_IN_DAYS
FROM
    HEALTHCARE.PATIENTS;
    
    -- How many states and zip codes do we treat patients from?
SELECT DISTINCT
    STATE
FROM
    HEALTHCARE.PATIENTS;
    
SELECT DISTINCT
    ZIP, COUNT(*)
FROM
    HEALTHCARE.PATIENTS
GROUP BY ZIP;
    
    -- Which state, zip and county do we treat the most patients from?
	SELECT DISTINCT
    COUNTY, COUNT(*)
FROM
    HEALTHCARE.PATIENTS
GROUP BY COUNTY;
    
    -- What is our patient mix for patients who had an inpatient encounter in 2019? 
    
SELECT 
    GENDER, RACE, ETHNICITY, COUNT(*) AS VOLUMES
FROM
    HEALTHCARE.ENCOUNTERS ENC
        JOIN
    HEALTHCARE.PATIENTS PAT ON ENC.PATIENT = PAT.ID
WHERE
    START >= '2019-01-01'
        AND START < '2020-01-01'
        AND ENCOUNTERCLASS = 'inpatient'
GROUP BY GENDER , RACE , ETHNICITY;
    
-- Given what is documented in this data set, how many different combinations of 
-- gender, race, and ethnicity exist in our patient population?

SELECT 
    GENDER, RACE, ETHNICITY, COUNT(*)
FROM
    HEALTHCARE.PATIENTS
GROUP BY GENDER , RACE , ETHNICITY;

-- Which county had the highest number of patients?

SELECT 
    county, COUNT(*) AS COUNT
FROM
    HEALTHCARE.PATIENTS
GROUP BY county
ORDER BY COUNT DESC;

-- How many inpatient encounters did we have in the entire dataset where 
-- the patient was at least 21 years old at the time of the encounter start?

SELECT 
    COUNT(FLOOR(DATEDIFF(CURDATE(), BIRTHDATE) / 365.25)) AS AGE_IN_DAYS
FROM
    HEALTHCARE.ENCOUNTERS ENC
        JOIN
    HEALTHCARE.PATIENTS PAT ON ENC.PATIENT = PAT.ID
WHERE
    FLOOR(DATEDIFF(START, BIRTHDATE) / 365.25) >= 21
        AND ENCOUNTERCLASS = 'inpatient';
