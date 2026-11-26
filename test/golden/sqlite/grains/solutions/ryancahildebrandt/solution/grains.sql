-- Schema: CREATE TABLE "grains" ("task" TEXT, "square" INT, "result" INT);
-- Task: update the grains table and set the result based on the task (and square fields).
UPDATE grains
set result = CASE task
    WHEN "total" THEN pow(2, 64) - 1
    ELSE pow(2, square - 1)
END