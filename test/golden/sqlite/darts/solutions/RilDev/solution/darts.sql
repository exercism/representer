-- Schema: CREATE TABLE "darts" ("x" REAL, "y" REAL, score INTEGER);
-- Task: update the darts table and set the score based on the x and y values.
UPDATE darts AS d
SET
    score = 
    CASE
        WHEN power(d.x, 2) + power(d.y, 2) <= 1 THEN 10
        WHEN power(d.x, 2) + power(d.y, 2) <= power(5, 2) THEN 5
        WHEN power(d.x, 2) + power(d.y, 2) <= power(10, 2) THEN 1
        ELSE 0
    END
;