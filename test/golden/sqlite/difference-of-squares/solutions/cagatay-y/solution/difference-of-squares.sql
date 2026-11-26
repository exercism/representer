-- Schema: CREATE TABLE "difference-of-squares" ("number" INT", property" TEXT, "result" INT);
-- Task: update the difference-of-squares table and set the result based on the number and property fields.
WITH intermediate AS (
    SELECT 
        number,
        POWER((number * (number + 1)) / 2, 2) as square_of_sum,
        (number * (number + 1) * (2 * number + 1)) / 6 as sum_of_squares
    FROM "difference-of-squares"
)
UPDATE "difference-of-squares"
    SET result = 
        CASE property 
            WHEN "squareOfSum" THEN square_of_sum
            WHEN "sumOfSquares" THEN sum_of_squares
            WHEN "differenceOfSquares" THEN square_of_sum - sum_of_squares
        END
    FROM intermediate WHERE "difference-of-squares".number = intermediate.number;
        