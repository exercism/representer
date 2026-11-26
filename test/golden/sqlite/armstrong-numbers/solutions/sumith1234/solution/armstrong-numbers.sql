-- Schema: CREATE TABLE "armstrong-numbers" ("number" INT, "result" BOOLEAN);
-- Task: update the armstrong-numbers table and set the result based on the number field.
WITH RECURSIVE sumDigits(number, sum, len, idx) AS (
	SELECT number, 0 AS sum, length(CAST(number AS TEXT)) AS len, 0 AS idx
	FROM "armstrong-numbers"
	UNION ALL
	SELECT number, sum + pow(CAST(SUBSTR(CAST(number AS TEXT), idx, 1) AS INT),len), len, idx + 1
	FROM sumDigits
	WHERE idx <= len
)
UPDATE "armstrong-numbers"
SET result = (sum = sumDigits.number)
FROM sumDigits
WHERE sumDigits.number = "armstrong-numbers".number