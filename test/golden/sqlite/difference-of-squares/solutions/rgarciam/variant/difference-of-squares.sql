-- Schema: CREATE TABLE "difference-of-squares" ("number" INT, "property" TEXT, "result" INT);
-- Task: update the difference-of-squares table and set the result based on the number and property fields.

UPDATE "difference-of-squares"
SET result =
    CASE property
        WHEN 'squareOfSum' THEN -- squareOfSum = (1 + 2 + ... + n)^2
            (number * (number + 1) / 2) * (number * (number + 1) / 2)
        WHEN 'sumOfSquares' THEN -- sumOfSquares = 1^2 + 2^2 + ... + n^2
            number * (number + 1) * (2 * number + 1) / 6
        WHEN 'differenceOfSquares' THEN 
            (number / (number + 1) / 2) * (number * (number + 1) / 2) - (number * (number + 1) * (2 * number + 1) / 6)
        ELSE 0
    END;