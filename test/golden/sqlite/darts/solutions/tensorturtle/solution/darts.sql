-- Schema: CREATE TABLE "darts" ("x" REAL, "y" REAL, score INTEGER);
-- Task: update the darts table and set the score based on the x and y values.

UPDATE darts
SET score = 
    CASE
        WHEN SQRT(POW(x,2) + POW(y,2)) > 10 THEN 0
        WHEN SQRT(POW(x,2) + POW(y,2)) > 5 THEN 1
        WHEN SQRT(POW(x,2) + POW(y,2)) > 1 THEN 5
        WHEN SQRT(POW(x,2) + POW(y,2)) > 0 THEN 10
        ELSE 10
    END;