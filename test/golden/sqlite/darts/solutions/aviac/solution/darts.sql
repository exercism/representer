-- Schema: CREATE TABLE "darts" ("x" REAL, "y" REAL, score INTEGER);
-- Task: update the darts table and set the score based on the x and y values.
with tmp as (
  select x as x_val, y as y_val, sqrt (x * x + y * y) as distance from darts
) update darts 
set score = (
  select score from (
    select distance,
      case 
        when distance > 10 then 0
        when distance > 5 then 1
        when distance > 1 then 5
        else 10 
      end as score
    from tmp
    where x_val = x and y_val = y
  )
); 
