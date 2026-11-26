-- Schema: CREATE TABLE "collatz" ("number" INTEGER, "steps" INTEGER);
-- Task: update the collatz table and set the steps based on the number.
WITH RECURSIVE cte(number, n, steps) AS (
    SELECT number, number, 0 from collatz
    UNION ALL
    SELECT number, IIF(n % 2, 3 * n + 1, n / 2), steps + 1
    FROM cte
    WHERE n != 1
)
UPDATE collatz
SET steps = cte.steps
FROM cte
WHERE collatz.number = cte.number;