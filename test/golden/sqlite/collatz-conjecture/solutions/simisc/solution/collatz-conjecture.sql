-- Schema: CREATE TABLE "collatz" ("number" INTEGER, "steps" INTEGER);
-- Task: update the collatz table and set the steps based on the number.

UPDATE collatz
SET steps = (
    WITH RECURSIVE cte (number, x) AS (
        SELECT number, number FROM collatz
        UNION ALL
        SELECT number, iif(x % 2, 3 * x + 1, x / 2) FROM cte
        WHERE x > 1
    )
    SELECT count(x) - 1 FROM cte
    WHERE cte.number = collatz.number
);
