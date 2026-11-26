-- Schema: CREATE TABLE "darts" ("x" REAL, "y" REAL, score INTEGER);
-- Task: update the darts table and set the score based on the x and y values.
UPDATE "darts" SET score = 0 WHERE SQRT(x * x + y * y) > 10;
UPDATE "darts" SET score = 1 WHERE SQRT(x * x + y * y) BETWEEN 5 and 10;
UPDATE "darts" SET score = 5 WHERE SQRT(x * x + y * y) BETWEEN 1 and 5;
UPDATE "darts" SET score = 10 WHERE SQRT(x * x + y * y) BETWEEN 0 and 1;