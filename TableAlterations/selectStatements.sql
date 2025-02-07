-- Question 1
SELECT title, length
FROM film
WHERE description IN '%fun%'  
    AND length < 120;

-- Question 2
SELECT title
FROM film
WHERE title IN '%a'
    OR title IN '%e'
    OR title IN '%i'
    OR title IN '%o'
    OR title IN '%u';

-- Question 3
SELECT title
FROM film
WHERE 120 <= length >= 180;

-- Question 4
SELECT title, length
FROM film
WHERE title IN '%river%'
    AND rating = 'PG' OR rating = 'PG-13';

-- Question 5
SELECT title
FROM film 
WHERE releaseYear > 2012
    AND length > 160;

-- Question 6
SELECT title, replacementCost, rating
WHERE title NOT IN '_a'
    replacementCost = 19.99;

-- Question 7
SELECT title
FROM film
WHERE description IS NULL;

-- Question 8
SELECT replacementCost
FROM film
WHERE title in 'Town Ark';

-- Question 9
SELECT title
FROM film
WHERE rating = 'G' AND releaseYear = 2006
    OR rating = 'PG' AND releaseYear = 2010;

-- Question 10
SELECT *
FROM film
WHERE releaseYear != 2006
    OR releaseYear != 2010;

-- Question 11
UPDATE film 
SET replacementCost = 5.59 -- new cost
WHERE releaseYear = 2006;

-- Question 12
UPDATE film SET replacementCost = 10.00 WHERE releaseYear = 2006;

-- Question 13
DELETE FROM films 
WHERE length < 60 AND rating = 'PG';
