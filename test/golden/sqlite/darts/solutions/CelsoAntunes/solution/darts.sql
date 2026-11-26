-- CREATE TABLE "darts" ("x" REAL, "y" REAL);
UPDATE "darts"
SET score = 10
WHERE power(x,2)+power(y,2)<=1;
UPDATE "darts"
SET score = 5
WHERE power(x,2)+power(y,2)<=25 AND power(x,2)+power(y,2)>1;
UPDATE "darts"
SET score = 1
WHERE power(x,2)+power(y,2)<=100 AND power(x,2)+power(y,2)>25;
UPDATE "darts"
SET score = 0
WHERE power(x,2)+power(y,2)>100;
-- Task: update the darts table and set the score based on the x and y values.
