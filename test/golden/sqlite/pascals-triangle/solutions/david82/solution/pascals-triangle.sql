-- Schema: CREATE TABLE "pascals-triangle" ("input" INT, "result" TEXT);
-- Task: update the pascals-triangle table and set the result based on the input field.
UPDATE "pascals-triangle"
SET result = (
  CASE 
    WHEN input = 0 THEN ''
    ELSE (
      WITH RECURSIVE counter(k) AS (
        SELECT 1 UNION ALL
        SELECT k + 1 FROM counter WHERE k < input
      )
        
      SELECT group_concat(
        (
          WITH RECURSIVE nums(idx, s) AS (
            SELECT 1, 1 UNION ALL
            SELECT idx + 1, s * k / idx - s FROM nums WHERE idx < k
          )
          SELECT group_concat(s, ' ') FROM nums
        ),
        char(10)  -- newline
      ) FROM counter
    )
  END
);
