-- Volume in Healthcare Data

SELECT 
    COUNT(*)
FROM
    Healthcare.encounters
WHERE
    START >= '2019-01-01'
        AND START < '2020-01-01';


-- How many distinct patients did we treat in 2019? 
SELECT 
    COUNT(DISTINCT Patient)
FROM
    Healthcare.encounters
WHERE
    START >= '2019-01-01'
        AND START < '2020-01-01';


-- How many inpatient encounters did we have in 2019?
SELECT 
    *
FROM
    Healthcare.encounters
WHERE
    START >= '2019-01-01'
        AND START < '2020-01-01'
        AND ENCOUNTERCLASS = 'inpatient';


-- How many ambulatory encounters did we have in 2019? 
SELECT 
    COUNT(ENCOUNTERCLASS)
FROM
    Healthcare.encounters
WHERE
    START >= '2019-01-01'
        AND START < '2020-01-01'
        AND ENCOUNTERCLASS = 'ambulatory';
    
-- reviewing encounter classes
SELECT DISTINCT
    ENCOUNTERCLASS
FROM
    Healthcare.encounters;

-- Same day visits
SELECT 
    COUNT(ENCOUNTERCLASS)
FROM
    Healthcare.encounters
WHERE
    START >= '2019-01-01'
        AND START < '2020-01-01'
        AND ENCOUNTERCLASS IN ('ambulatory' , 'wellness', 'outpatient', 'urgentcare');
    
-- How many encounters did we have before the year 2020?

SELECT 
    COUNT(*)
FROM
    Healthcare.encounters
WHERE
    START < '2020-01-01';

-- How many distinct patients did we treat before the year 2020?

SELECT 
    COUNT(DISTINCT PATIENT)
FROM
    Healthcare.encounters
WHERE
    START < '2020-01-01';

-- How many distinct encounter classes are documented in the HEALTHCARE.ENCOUNTERS table?
SELECT 
    COUNT(DISTINCT ENCOUNTERCLASS)
FROM
    Healthcare.encounters;

-- How many inpatient and ambulatory encounters did we have before 2020?
SELECT 
    COUNT(*)
FROM
    Healthcare.encounters
WHERE
    START < '2020-01-01'
        AND ENCOUNTERCLASS IN ('inpatient' , 'ambulatory');
    
    

