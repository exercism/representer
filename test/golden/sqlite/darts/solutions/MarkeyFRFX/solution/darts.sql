-- Schema: CREATE TABLE "darts" ("x" REAL, "y" REAL, score INTEGER);
-- Task: update the darts table and set the score based on the x and y values.

UPDATE darts
    SET score = IIF(SQRT(POWER(x, 2) + POWER(y,2)) > 10, 0,
                   IIF(SQRT(POWER(x, 2) + POWER(y,2)) > 5, 1, 
                      IIF(SQRT(POWER(x,2) + POWER(y,2)) > 1, 5, 10)))