-- Schema: CREATE TABLE "armstrong-numbers" ("number" INT, "result" BOOLEAN);
-- Task: update the armstrong-numbers table and set the result based on the number field.

UPDATE "armstrong-numbers" SET result = (
    WITH RECURSIVE 
        DIGITS(x, digit) AS (
            SELECT number / 10, number % 10
            UNION ALL
            SELECT x / 10, x % 10 FROM DIGITS WHERE x ==0
        )
    SELECT SUM(POW(digit, length(number))) == number FROM DIGITS
)