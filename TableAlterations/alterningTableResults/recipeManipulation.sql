USE recipes;

SELECT name 
FROM recipe
WHERE name = "Linguine Pescadoro"
OR name = "Zuppa Inglese";

SELECT recipe.name 
FROM recipe, nutrition
WHERE nutrition.recipeID = recipe.recipeID
AND nutrition.name = "calories"
AND nutrition.quantity < 800;

SELECT i.name il.quantity
FROM recipe r
JOIN ingredientList il ON r.recipeID = il.recipeID
JOIN ingredient i ON il.ingredientID = i.ingredientID
WHERE r.name LIKE "Beef Parmesan%";

SELECT name
FROM recipe
WHERE recipeID NOT IN (
    SELECT il.recipeID
    FROM ingredientList il
    JOIN ingredient i ON il.ingredientID = i.ingredientID
    WHERE i.type IN ("beef", "pork", "chicken", "lamb")
);

SELECT recipe.name 
FROM recipe
JOIN nutrition n ON recipe.recipeID = n.recipeID
WHERE n.name = "calories"
AND n.quantity < 700;
