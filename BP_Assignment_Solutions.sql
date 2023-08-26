-- If we used a lower cut off of 135/85 for hypertension than the 140/90 discussed in the lecture, how many patients would have been documented hypertension at any time across 2018 or 2019?

SELECT DISTINCT PATIENT
FROM HEALTHCARE.OBSERVATIONS
WHERE 
				(
                
					(DESCRIPTION = 'Diastolic Blood Pressure' AND VALUE>85)
						OR (DESCRIPTION = 'Systolic Blood Pressure' AND VALUE>135)
				
                )
                
                AND DATE>='2018-01-01'
                AND DATE<'2020-01-01';


-- What were the most commonly prescribed medications to the patients with hypertension (as identified as having a BP over 140/90 at any point in 2018 or 2019)?


SELECT DISTINCT MED.DESCRIPTION AS MEDICATION
,COUNT(*) AS TOTAL_MEDS
FROM HEALTHCARE.OBSERVATIONS BP
JOIN HEALTHCARE.MEDICATIONS MED ON BP.PATIENT=MED.PATIENT
																			AND MED.START>=BP.DATE
WHERE 
				(
                
					(BP.DESCRIPTION = 'Diastolic Blood Pressure' AND BP.VALUE>90)
						OR (BP.DESCRIPTION = 'Systolic Blood Pressure' AND BP.VALUE>140)
				
                )
                
                AND BP.DATE>='2018-01-01'
                AND BP.DATE<'2020-01-01'
                GROUP BY MED.DESCRIPTION;


-- Which race (in this data set) had the highest total number of patients with a BP of 140/90 before 2020?

SELECT PAT.RACE
,COUNT(DISTINCT PAT.ID) AS DISTINCT_PATIENTS
FROM HEALTHCARE.OBSERVATIONS  BP
JOIN HEALTHCARE.PATIENTS PAT ON BP.PATIENT=PAT.ID
WHERE 
				(
                
					(DESCRIPTION = 'Diastolic Blood Pressure' AND VALUE>90)
						OR (DESCRIPTION = 'Systolic Blood Pressure' AND VALUE>140)
				
                )
                
               AND  DATE<'2020-01-01'
                GROUP BY PAT.RACE;

-- Which race (in this training data set) had the highest percentage of blood pressure readings that were above 140/90 before 2020?


-- we will actually create two inner queries to answer this one, which really tries to ty together most of the concepts we covered in this course

SELECT TOTAL_BPS.RACE
,TOTAL_BPS.TOTAL_BP_READINGS
,POSITIVE_BPS.TOTAL_HIGH_BP_READINGS
,100*(POSITIVE_BPS.TOTAL_HIGH_BP_READINGS/TOTAL_BP_READINGS) AS PERCENT_HIGH_BPS
FROM
							(
								-- determine total number of BP readings done by race
									SELECT PAT.RACE
									,COUNT(*) / 2 AS TOTAL_BP_READINGS -- we divide by two because otherwise we'd be counting readings double (due to us getting one row per diastolic and one row per systolic
									FROM HEALTHCARE.OBSERVATIONS  BP
									JOIN HEALTHCARE.PATIENTS PAT ON BP.PATIENT=PAT.ID
									WHERE 
													(
													
														(DESCRIPTION = 'Diastolic Blood Pressure' )
															OR (DESCRIPTION = 'Systolic Blood Pressure' )
													
													)
													
												   AND  DATE<'2020-01-01'
													GROUP BY PAT.RACE
                                ) TOTAL_BPS

LEFT JOIN 		(
							-- determine number of BP readings where we have high blood pressure documented
								SELECT PAT.RACE
								,COUNT(*)/2 AS TOTAL_HIGH_BP_READINGS
								FROM HEALTHCARE.OBSERVATIONS  BP
								JOIN HEALTHCARE.PATIENTS PAT ON BP.PATIENT=PAT.ID
								WHERE 
												(
												
													(DESCRIPTION = 'Diastolic Blood Pressure' AND VALUE>90)
														OR (DESCRIPTION = 'Systolic Blood Pressure' AND VALUE>140)
												
												)
												
											   AND  DATE<'2020-01-01'
												GROUP BY PAT.RACE
							) POSITIVE_BPS ON TOTAL_BPS.RACE=POSITIVE_BPS.RACE
		;
