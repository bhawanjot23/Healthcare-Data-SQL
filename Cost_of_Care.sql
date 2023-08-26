-- Cost of Care

-- Why we look at cost of care? 
	-- Cost of care in the US varies by many facotrs including care received and healthcare insurance coverage
    -- Financial impact of cost of care can have a real impact on each patient
    
-- What is total claim cost for each encounter in 2019?

SELECT 
    SUM(TOTAL_CLAIM_COST) AS TOTAL_2019,
    AVG(TOTAL_CLAIM_COST) AS AVG_2019
FROM
    HEALTHCARE.ENCOUNTERS
WHERE
    START >= '2019-01-01'
        AND START < '2020-01-01';

-- What is total payer coverage for each encounter in 2019? 
SELECT 
    SUM(TOTAL_CLAIM_COST) AS TOTAL_CLAIMS_2019,
    AVG(TOTAL_CLAIM_COST) AS AVG__CLAIMS_2019,
    SUM(PAYER_COVERAGE) AS TOTAL_PAYER_COVERAGE_2019,
    AVG(PAYER_COVERAGE) AS AVG_PAYER_COVERAGE_2019
FROM
    HEALTHCARE.ENCOUNTERS
WHERE
    START >= '2019-01-01'
        AND START < '2020-01-01';

-- Which encounter types had the highest cost? 

SELECT 
    ENCOUNTERCLASS,
    SUM(TOTAL_CLAIM_COST) AS TOTAL_2019,
    AVG(TOTAL_CLAIM_COST) AS AVG_2019
FROM
    HEALTHCARE.ENCOUNTERS
WHERE
    START >= '2019-01-01'
        AND START < '2020-01-01'
GROUP BY ENCOUNTERCLASS;

-- Which encounter types had the highest cost covered by payers? 

SELECT 
    PAYER,
    NAME,
    ENCOUNTERCLASS,
    SUM(TOTAL_CLAIM_COST) - SUM(PAYER_COVERAGE) AS DIFFER_CLAIM_TO_PAYER_COV_TOT,
    AVG(TOTAL_CLAIM_COST) - AVG(PAYER_COVERAGE) AS DIFFER_CLAIM_TO_PAYER_COV_AVG
FROM
    HEALTHCARE.ENCOUNTERS ENC
        JOIN
    HEALTHCARE.PAYERS PAY ON ENC.PAYER = PAY.ID
        AND START >= '2019-01-01'
        AND START < '2020-01-01'
GROUP BY PAYER , NAME , ENCOUNTERCLASS
ORDER BY ENCOUNTERCLASS;

-- What was the total claim cost for encounters before 2020? Return answer in whole dollars (round up to nearest dollar).
SELECT 
    ENCOUNTERCLASS, ROUND(SUM(TOTAL_CLAIM_COST)) AS TOTAL
FROM
    HEALTHCARE.ENCOUNTERS
WHERE
    START < '2020-01-01'
GROUP BY ENCOUNTERCLASS
ORDER BY TOTAL;


-- What was the total payer coverage for encounters before 2020? Return answer in whole dollars (round up to nearest dollar).
SELECT 
    ENCOUNTERCLASS,
    ROUND(SUM(PAYER_COVERAGE)) AS TOTAL_PAYER_COVERAGE
FROM
    HEALTHCARE.ENCOUNTERS
WHERE
    START < '2020-01-01'
GROUP BY ENCOUNTERCLASS
ORDER BY TOTAL_PAYER_COVERAGE;
-- Which payer (per this training dataset) had the highest claim coverage percentage (total payer coverage/ total claim cost) for encounters before 2020?
SELECT 
    NAME,
    AVG(PAYER_COVERAGE / TOTAL_CLAIM_COST * 100) AS Percent
FROM
    HEALTHCARE.ENCOUNTERS ENC
        JOIN
    HEALTHCARE.PAYERS PAY ON ENC.PAYER = PAY.ID
WHERE
    START < '2020-01-01'
GROUP BY NAME
ORDER BY Percent;

-- Which payer (per this training dataset) had the highest claim coverage percentage (total payer coverage / total claim cost) for ambulatory encounters before 2020?

SELECT 
    NAME,
    AVG(PAYER_COVERAGE / TOTAL_CLAIM_COST * 100) AS Percent
FROM
    HEALTHCARE.ENCOUNTERS ENC
        JOIN
    HEALTHCARE.PAYERS PAY ON ENC.PAYER = PAY.ID
WHERE
    START < '2020-01-01'
        AND ENCOUNTERCLASS = 'ambulatory'
GROUP BY NAME
ORDER BY Percent;