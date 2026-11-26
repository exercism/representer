-- Schema: CREATE TABLE "difference-of-squares" ("number" INT, "property" TEXT, "result" INT);
-- Task: update the difference-of-squares table and set the result based on the number and property fields.

--  Formula: Difference of Squares= N⋅(N−1)⋅(N+1)⋅(3N+2) / 12
-- Squares of Sum = POWER(N . (N + 1) / 2), 2)
-- Sum of Squares = N . (N + 1) . (2.N + 1) / 6


UPDATE "difference-of-squares"
SET result = CASE
    WHEN property = 'squareOfSum'
        THEN POWER((number * (number + 1)) / 2, 2) 
    WHEN property = 'sumOfSquares'
        THEN number * (number + 1) * (2 * number + 1) / 6
    WHEN property = 'differenceOfSquares'
        THEN number * (number - 1) * (number + 1) * ((3 * number) + 2) / 12
END;

