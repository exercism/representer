-- Schema: CREATE TABLE "darts" ("x" REAL, "y" REAL, score INTEGER);
-- Task: update the darts table and set the score based on the x and y values.


UPDATE darts
SET score = CASE
    WHEN SQRT(ABS(POWER(x, 2) + POWER(y, 2))) > 10 THEN 0
    WHEN SQRT(ABS(POWER(x, 2) + POWER(y, 2))) BETWEEN 5.01 AND 10 THEN 1
    WHEN SQRT(ABS(POWER(x, 2) + POWER(y, 2))) BETWEEN 1.01 AND 5 THEN 5
    ELSE 10
END