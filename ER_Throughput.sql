-- What is happening in the ER
	-- ER throughput is a key indicator of volume, patient acess, and system's ability to support its community.
    
-- Questions We Will Answer with SQL

-- How many emergency encounters did we have in 2019? 
SELECT 
    COUNT(*)
FROM
    Healthcare.encounters
WHERE
    START >= '2019-01-01'
        AND START < '2020-01-01'
        AND ENCOUNTERCLASS = 'emergency';


-- What conditions were treated in those encounters?
SELECT 
    CON.DESCRIPTION, COUNT(*) AS COUNT
FROM
    Healthcare.encounters ENC
        LEFT JOIN
    Healthcare.conditions CON ON ENC.Id = CON.ENCOUNTER
WHERE
    ENC.START >= '2019-01-01'
        AND ENC.START < '2020-01-01'
        AND ENCOUNTERCLASS = 'emergency'
GROUP BY CON.DESCRIPTION
ORDER BY COUNT DESC;

-- What was the emergency throughput and how did that vary by condition treated?

SELECT 
    THROUGHPUT.DESCRIPTION, AVG(THROUGHPUT_IN_MIN) AS THR_AVG
FROM
    (SELECT 
        *, TIMESTAMPDIFF(MINUTE, START, STOP) THROUGHPUT_IN_MIN
    FROM
        Healthcare.encounters ENC
    LEFT JOIN Healthcare.conditions CON ON ENC.Id = CON.ENCOUNTER
    WHERE
        ENC.START >= '2019-01-01'
            AND ENC.START < '2020-01-01'
            AND ENCOUNTERCLASS = 'emergency') THROUGHPUT
GROUP BY THROUGHPUT.DESCRIPTION;
        
-- How many emergency encounters did we have before 2020?

SELECT 
    COUNT(*)
FROM
    Healthcare.encounters
WHERE
    START < '2020-01-01'
        AND ENCOUNTERCLASS = 'emergency';
    
-- Other than nulls (where no condition was documented), 
-- which condition was most documented for emergency encounters before 2020?

SELECT 
    con.description, COUNT(*) AS COUNT
FROM
    Healthcare.encounters enc
        LEFT JOIN
    healthcare.conditions con ON enc.Id = con.encounter
WHERE
    enc.START < '2020-01-01'
        AND ENCOUNTERCLASS = 'emergency'
GROUP BY con.description
ORDER BY COUNT DESC;

-- How many conditions for emergency encounters before 2020 had 
-- average ER throughputs above 100 minutes? Don't count nulls if they appear 
-- in your solution.

SELECT 
    *
FROM
    (SELECT 
        THROUGHPUT.DESCRIPTION, AVG(THROUGHPUT_IN_MIN) AS THR_AVG
    FROM
        (SELECT 
        ENC.ID,
            CON.DESCRIPTION,
            TIMESTAMPDIFF(MINUTE, ENC.START, ENC.STOP) THROUGHPUT_IN_MIN
    FROM
        HEALTHCARE.ENCOUNTERS ENC
    LEFT JOIN HEALTHCARE.CONDITIONS CON ON ENC.ID = CON.ENCOUNTER
    WHERE
        ENC.START < '2020-01-01'
            AND ENC.ENCOUNTERCLASS = 'emergency') THROUGHPUT
    GROUP BY THROUGHPUT.DESCRIPTION) CONDITION_AVGS
WHERE
    CONDITION_AVGS.THR_AVG > 100