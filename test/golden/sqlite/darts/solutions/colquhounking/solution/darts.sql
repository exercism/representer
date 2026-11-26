-- Schema: CREATE TABLE "darts" ("x" REAL, "y" REAL, score INTEGER);
-- Task: update the darts table and set the score based on the x and y values.
update darts
set score = case
when ( x * x + y * y) > 100 then 0 -- (because 100 is 10 * 10?)
when ( x * x + y * y) > 25 then 1 -- (and 25 is 5 * 5?)
when ( x * x + y * y) > 1 then 5 -- (and 1 is 1 * 1?)
else 10 -- (Ohhhh, I think I've got it, so if you draw a radius round 0,0 of 10 then anything times itself, added together will be outside it)
end;