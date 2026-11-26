-- Schema: CREATE TABLE "darts" ("x" REAL, "y" REAL, score INTEGER);
-- Task: update the darts table and set the score based on the x and y values.

UPDATE darts 
SET score =
    CASE
        WHEN (y * y + x * x) > 100 THEN 0
        WHEN (y * y + x * x) > 25 THEN 1
        WHEN (y * y + x * x) > 1 THEN 5
        ELSE 10
    END;

SELECT * FROM darts;
