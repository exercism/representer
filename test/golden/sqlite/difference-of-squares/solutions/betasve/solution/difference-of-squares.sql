-- Schema: CREATE TABLE "difference-of-squares" ("number" INT", property" TEXT, "result" INT);
-- Task: update the difference-of-squares table and set the result based on the number and property fields.


UPDATE "difference-of-squares"
  SET result =
    CASE
        WHEN property == "squareOfSum" THEN (
            WITH RECURSIVE sequence AS (
                SELECT 1 AS num
                UNION ALL
                SELECT num + 1
                FROM sequence
                WHERE num <  number
            )

            SELECT pow(sum(num),2) as res
            FROM sequence
        )
        WHEN property == "sumOfSquares" THEN (
            WITH RECURSIVE sequence AS (
                SELECT 1 AS num
                UNION ALL
                SELECT num + 1
                FROM sequence
                WHERE num <  number
            )

            SELECT sum(pow(num, 2)) as res
            FROM sequence
        )
        WHEN property == "differenceOfSquares" THEN (
            WITH RECURSIVE sequence AS (
                SELECT 1 AS num
                UNION ALL
                SELECT num + 1
                FROM sequence
                WHERE num <  number
            )

            SELECT (pow(sum(num),2) - sum(pow(num, 2))) as res
            FROM sequence
        )
        ELSE 0
    END;

