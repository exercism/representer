-- Schema: CREATE TABLE "difference-of-squares" ("number" INT", property" TEXT, "result" INT);
-- Task: update the difference-of-squares table and set the result based on the number and property fields.
-- Function to calculate the square of the sum
UPDATE "difference-of-squares"
SET result = CASE
    WHEN property = 'squareOfSum' THEN (number * (number + 1) / 2) * (number * (number + 1) / 2)
    WHEN property = 'sumOfSquares' THEN number * (number + 1) * (2 * number + 1) / 6
    WHEN property = 'differenceOfSquares' THEN ABS((number * (number + 1) * (2 * number + 1) / 6) - ((number * (number + 1) / 2) * (number * (number + 1) / 2)))
    ELSE NULL
END;
