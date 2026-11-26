-- Schema: CREATE TABLE "grains" ("task" TEXT, "square" INT, "result" INT);
-- Task: update the grains table and set the result based on the task (and square fields).
update grains set result=CASE
 task WHEN'single-square' THEN
POWER(2,square-1)
WHEN 'total' THEN
POWER(2,64)-1 
END;