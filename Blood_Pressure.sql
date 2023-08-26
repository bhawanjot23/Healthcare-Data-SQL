 
-- Why do we want to look at blood pressure management? 
	-- Patients with uncontrolled hypertension
    -- Payer contracts (Value Based Contracts)


-- How many patients had documented uncontrolled hypertension at any time in 2018 and 2019?
	SELECT DISTINCT
    PATIENT
FROM
    HEALTHCARE.observations BP
WHERE
    ((DESCRIPTION = 'Diastolic Blood Pressure'
        AND VALUE > 90)
        OR (DESCRIPTION = 'Systolic Blood Pressure'
        AND VALUE > 140))
        AND DATE >= '2018-01-01'
        AND DATE < '2020-01-01';


-- Which providers treated patients with uncontrolled hypertension in 2018 and 2019? 
SELECT DISTINCT
    BP.PATIENT, PRO.NAME, PRO.SPECIALITY
FROM
    HEALTHCARE.observations BP
        JOIN
    HEALTHCARE.ENCOUNTERS ENC ON BP.ENCOUNTER = ENC.ID
        JOIN
    HEALTHCARE.PROVIDERS PRO ON ENC.PROVIDER = PRO.ID
WHERE
    ((BP.DESCRIPTION = 'Diastolic Blood Pressure'
        AND VALUE > 90)
        OR (BP.DESCRIPTION = 'Systolic Blood Pressure'
        AND VALUE > 140))
        AND BP.DATE >= '2018-01-01'
        AND BP.DATE < '2020-01-01';
-- What medications were given to patients with uncontrolled hypertension? 

SELECT DISTINCT
    BP.PATIENT, MED.DESCRIPTION AS MEDICATION
FROM
    HEALTHCARE.observations BP
        JOIN
    HEALTHCARE.MEDICATIONS MED ON BP.PATIENT = MED.PATIENT
        AND MED.START >= BP.DATE
WHERE
    ((BP.DESCRIPTION = 'Diastolic Blood Pressure'
        AND BP.VALUE > 90)
        OR (BP.DESCRIPTION = 'Systolic Blood Pressure'
        AND BP.VALUE > 140))
        AND BP.DATE >= '2018-01-01'
        AND BP.DATE < '2020-01-01';
        
-- If we used a lower cut off of 135/85 for hypertension than the 140/90 discussed in the lecture, 
-- how many patients would have been documented hypertension at any time across 2018 or 2019?

SELECT DISTINCT
    PATIENT
FROM
    HEALTHCARE.observations BP
WHERE
    ((DESCRIPTION = 'Diastolic Blood Pressure'
        AND VALUE > 85)
        OR (DESCRIPTION = 'Systolic Blood Pressure'
        AND VALUE > 135))
        AND DATE >= '2018-01-01'
        AND DATE < '2020-01-01';
        
-- What was the most commonly prescribed medication to the patients with hypertension 
-- (as identified as having a BP over 140/90 at any point in 2018 or 2019)?

SELECT 
    MED.DESCRIPTION AS MEDICATION, COUNT(*)
FROM
    HEALTHCARE.observations BP
        JOIN
    HEALTHCARE.MEDICATIONS MED ON BP.PATIENT = MED.PATIENT
        AND MED.START >= BP.DATE
WHERE
    ((BP.DESCRIPTION = 'Diastolic Blood Pressure'
        AND BP.VALUE > 90)
        OR (BP.DESCRIPTION = 'Systolic Blood Pressure'
        AND BP.VALUE > 140))
        AND BP.DATE >= '2018-01-01'
        AND BP.DATE < '2020-01-01'
GROUP BY MEDICATION;

-- Which race (in this data set) had the highest total number of patients with a BP of 140/90 before 2020?

SELECT 
    RACE, COUNT(*)
FROM
    HEALTHCARE.observations BP
        JOIN
    HEALTHCARE.patients PAT ON BP.PATIENT = PAT.ID
WHERE
    ((BP.DESCRIPTION = 'Diastolic Blood Pressure'
        AND BP.VALUE > 90)
        OR (BP.DESCRIPTION = 'Systolic Blood Pressure'
        AND BP.VALUE > 140))
        AND BP.DATE >= '2018-01-01'
        AND BP.DATE < '2020-01-01'
GROUP BY RACE
