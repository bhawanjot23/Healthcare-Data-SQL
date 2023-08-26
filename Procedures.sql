-- What procedures are we performing? 
	-- Why we look at procedures? 
		-- Many treatments for patients may require procedures, analyzing this can help us identify what procedures
        -- are needed most to guide further expansion of support?

-- How many different types of procedures did we perform in 2019? 
SELECT 
    DESCRIPTION, COUNT(*)
FROM
    Healthcare.procedures
WHERE
    DATE < '2020-01-01'
        AND DATE >= '2019-01-01'
GROUP BY DESCRIPTION
ORDER BY COUNT(*) DESC;


-- How many procedures were performed across each care setting (inpatient/ambulatory)? 
SELECT 
    *
FROM
    (SELECT 
        ENCOUNTERCLASS, COUNT(*) AS TOTAL_COUNT
    FROM
        Healthcare.procedures PRC
    JOIN HEALTHCARE.ENCOUNTERS ENC ON PRC.ENCOUNTER = ENC.ID
    WHERE
        DATE < '2020-01-01'
            AND DATE >= '2019-01-01'
    GROUP BY ENCOUNTERCLASS) PROCS
ORDER BY TOTAL_COUNT DESC;
-- Which organizations performed the most inpatient procedures in 2019? 


SELECT 
    *
FROM
    (SELECT 
        NAME, COUNT(*) AS COUNT
    FROM
        HEALTHCARE.PROCEDURES PROCS
    JOIN HEALTHCARE.ENCOUNTERS ENC ON PROCS.ENCOUNTER = ENC.ID
    JOIN HEALTHCARE.ORGANIZATIONS ORG ON ENC.ORGANIZATION = ORG.ID
    WHERE
        DATE >= '2019-01-01'
            AND DATE < '2020-01-01'
            AND ENCOUNTERCLASS = 'inpatient'
    GROUP BY NAME) ORGS
ORDER BY COUNT DESC;


-- How many Colonoscopy procedures were performed before 2020?
SELECT 
    DESCRIPTION, COUNT(*)
FROM
    Healthcare.procedures
WHERE
    DATE < '2020-01-01'
        AND DESCRIPTION = 'Colonoscopy'
GROUP BY DESCRIPTION
ORDER BY COUNT(*) DESC;


-- Compare our total number of procedures in 2018 to 2019. Did we perform more procedures in 2019 or less?
SELECT 
    YEAR, COUNT(*)
FROM
    (SELECT 
        DESCRIPTION, YEAR(DATE) AS YEAR
    FROM
        Healthcare.procedures) TBL
WHERE
    YEAR = '2018' OR YEAR = '2019'
GROUP BY YEAR;
-- More procedures in 2018. 

SELECT 
    ORGANIZATION, COUNT(*) AS COUNT
FROM
    healthcare.procedures PROC
        JOIN
    healthcare.encounters ENC ON PROC.ENCOUNTER = ENC.ID
        JOIN
    HEALTHCARE.ORGANIZATIONS ORG ON ORG.ID = ENC.ORGANIZATION
WHERE
    PROC.DESCRIPTION = 'Auscultation of the fetal heart'
        AND DATE < '2020-01-01'
GROUP BY Organization
ORDER BY COUNT DESC;


-- Which race (in this training dataset) had the highest number of procedures done in 2019?
SELECT 
    RACE, COUNT(*) AS COUNT
FROM
    healthcare.procedures PROC
        JOIN
    healthcare.patients PAT ON PROC.PATIENT = PAT.ID
WHERE
    DATE >= '2019-01-01'
        AND DATE < '2020-01-01'
GROUP BY RACE;


-- Which race (in this training dataset) had the highest number of Colonoscopy procedures performed before 2020?
SELECT 
    RACE, COUNT(*) AS COUNT
FROM
    healthcare.procedures PROC
        JOIN
    healthcare.patients PAT ON PROC.PATIENT = PAT.ID
WHERE
    DATE >= '2019-01-01'
        AND DATE < '2020-01-01'
        AND DESCRIPTION = 'Colonoscopy'
GROUP BY RACE;