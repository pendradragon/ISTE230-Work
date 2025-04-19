USE jobsV2

SELECT stateCode AS location
FROM employer
UNION
SELECT location
FROM quarter;

SELECT employer.companyName, 
    employer.division, 
    employer.stateCode,
    interview.salaryOffered
FROM employer, interview
WHERE
    employer.companyName = interview.companyName
    AND employer.division = interview.division;

SELECT *
FROM state
WHERE (stateCode) NOT IN (
        SELECT stateCode
        FROM employer
);


SELECT companyName, minHrsOffered
FROM interview
WHERE minHrsOffered >= 40; 

SELECT *
FROM state
WHERE description LIKE '___a%',
    OR description LIKE '___e%',
    OR description LIKE '___i%',
    OR description LIKE '___o%',
    OR description LIKE '___u%';

SELECT 
    quarter.qtrCode, 
    quarter.location, 
    state.description
FROM quarter
JOIN 
state ON quarter.location = state.stateCode; 

SELECT 
    state.stateCode, 
    state.description, 
    employer.companyName
FROM state
LEFT JOIN 
    employer ON state.stateCode = employer.stateCode
ORDER BY 
    state.stateCode, employer.companyName;
