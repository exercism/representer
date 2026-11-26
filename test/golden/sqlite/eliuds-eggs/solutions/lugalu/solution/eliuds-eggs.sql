-- Schema: CREATE TABLE "eliuds-eggs" ("number" INT, "result" INT);
-- Task: update the eliuds-eggs table and set the result based on the number field.

WITH RECURSIVE countBits(sum, num, mask) AS (
	SELECT 0 as sum, number as num, 1 as mask
	FROM "eliuds-eggs"

	UNION ALL

	SELECT sum + IIF(num & mask = mask, 1, 0), num, mask << 1
	FROM countBits
	WHERE mask <= num
)

UPDATE "eliuds-eggs"
SET result = (
	SELECT sum 
	FROM countBits 
	WHERE countBits.num = "eliuds-eggs".number
	ORDER BY mask DESC
	LIMIT 1
)