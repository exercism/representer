-- Schema: CREATE TABLE "eliuds-eggs" ("number" INT, "result" INT);
-- Task: update the eliuds-eggs table and set the result based on the number field.
CREATE TEMPORARY TABLE bits AS
WITH RECURSIVE count(n) AS (
  SELECT 0
     UNION ALL
  SELECT n+1 
    FROM count 
   WHERE n < 31
)
SELECT * FROM count;
UPDATE "eliuds-eggs"
SET result = (SELECT COUNT(*) FROM bits WHERE (number & (1 << bits.n)) <> 0);