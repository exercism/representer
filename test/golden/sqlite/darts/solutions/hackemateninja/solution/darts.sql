-- Schema: CREATE TABLE "darts" ("x" REAL, "y" REAL, score INTEGER);
-- Task: update the darts table and set the score based on the x and y values.

insert into darts values (-9, 9, 0);
insert into darts values (0, 10, 1);
insert into darts values (-5, 0, 5);
insert into darts values (0, -1, 10);
insert into darts values (0, 0, 10);
insert into darts values (-0.1, -0.1, 10);
insert into darts values (0.7, 0.7, 10);
insert into darts values (0.8, -0.8, 5);
insert into darts values (-3.5, 3.5, 5);
insert into darts values (-3.6, -3.6, 1);
insert into darts values (-7.0, 7.0, 1);
insert into darts values (7.1, -7.1, 0);
insert into darts values (0.5, -4, 5);

SELECT x, y,
       CASE
           WHEN SQRT(POW(x, 2) + POW(y, 2)) > 10 THEN 0
           WHEN SQRT(POW(x, 2) + POW(y, 2)) > 5 THEN 1
           WHEN SQRT(POW(x, 2) + POW(y, 2)) > 1 THEN 5
           ELSE 10
       END AS score
FROM darts;