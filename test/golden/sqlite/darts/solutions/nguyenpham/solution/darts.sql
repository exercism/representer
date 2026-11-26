-- Schema: CREATE TABLE "darts" ("x" REAL, "y" REAL, score INTEGER);
-- Task: update the darts table and set the score based on the x and y values.
with r as (
select x, y, (x*x) + (y*y) as r2
from "darts"
),
scores as (
select
    x,
    y,
    case
        when r2 > 100 then 0
        when r2 > 25 and r2 <= 100 then 1
        when r2 > 1 and r2 <= 25 then 5
        else 10
    end as score
from r
)
update "darts" as target
set score = source.score
from scores as source
where source.x = target.x
and source.y = target.y;

