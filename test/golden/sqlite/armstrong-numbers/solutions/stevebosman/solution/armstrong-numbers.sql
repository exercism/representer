-- Schema: CREATE TABLE "armstrong-numbers" ("number" INT, "result" BOOLEAN);
-- Task: update the armstrong-numbers table and set the result based on the number field.
WITH RECURSIVE sums(number, len, pos, remaining, sum) AS (
    SELECT number, length(CAST(number AS TEXT)), 0, number, 0
    FROM "armstrong-numbers"
    UNION ALL
    SELECT number, len,  pos + 1,
           remaining/10, sum + pow(remaining % 10, len)
    FROM sums
    WHERE len >= pos
)
UPDATE "armstrong-numbers"
SET    result = (sums.sum = sums.number)
FROM   sums
WHERE  "armstrong-numbers".number = sums.number
AND    sums.pos = sums.len + 1;
