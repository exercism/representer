-- Schema: CREATE TABLE "darts" ("x" REAL, "y" REAL, score INTEGER);
-- Task: update the darts table and set the score based on the x and y values.
/*UPDATE TABLE darts(
    x REAL,
    y REAL,
    score CASE WHEN  x < 2 AND Y < 2 AND x > -2 AND y > -2 THEN 10 
    when x < 5 AND Y < 5 AND x > -5 AND y > -5 THEN 5
    when x < 10 AND Y < 10 AND x > -10 AND y > -10 THEN 1
    ELSE 0 END
)*/
UPDATE darts
SET score = CASE
    WHEN SQRT(x * x + y * y) <= 1 THEN 10  -- Inner circle (bullseye)
    WHEN SQRT(x * x + y * y) <= 5 THEN 5   -- Middle circle
    WHEN SQRT(x * x + y * y) <= 10 THEN 1  -- Outer circle
    ELSE 0                                 -- Outside target
END;
