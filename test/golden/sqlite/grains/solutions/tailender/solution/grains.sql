-- Schema: CREATE TABLE "grains" ("task" TEXT, "square" INT, "result" INT);
-- Task: update the grains table and set the result based on the task (and square fields).

update grains
set 
result = case 
            when task='single-square' then pow(2,square-1)
            else pow(2, 64) - 1
        end