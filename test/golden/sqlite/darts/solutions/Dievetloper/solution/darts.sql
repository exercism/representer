-- Schema: CREATE TABLE "darts" ("x" REAL, "y" REAL, score INTEGER);
-- Task: update the darts table and set the score based on the x and y values.

update darts
set score = case 
            when SQRT(x*x + y*y) <= 1 then 10
            when SQRT(x*x + y*y) <= 5  then 5
            when SQRT(x*x + y*y) <= 10 then 1
            else 0
        end