-- Schema: CREATE TABLE "collatz" ("number" INTEGER, "steps" INTEGER);
-- Task: update the collatz table and set the steps based on the number.

WITH RECURSIVE calculateSteps(number, x, steps) AS (
 SELECT number, number , 0
 FROM collatz
 UNION ALL

 SELECT number, IIF(x % 2, x * 3 + 1, x / 2), steps + 1
 FROM calculateSteps
 WHERE x > 1 
)

UPDATE collatz
SET steps = (
		SELECT MAX(steps)
		from calculateSteps
		WHERE calculateSteps.number = collatz.number
	);
