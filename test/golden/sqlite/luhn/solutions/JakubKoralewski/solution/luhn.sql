-- Schema: CREATE TABLE "luhn" ("value" TEXT "result" Boolean);
-- Task: update the luhn table and set the result based on the value field.

UPDATE luhn SET result = (
    WITH stripped(strippedvalue) AS (
        SELECT replace(value, ' ', '')
    )
    SELECT 
        CASE 
            WHEN LENGTH(strippedvalue) <= 1 THEN 0
            WHEN strippedvalue GLOB '*[^0-9]*' THEN 0
            ELSE (
                WITH RECURSIVE L(digit1, digit2, i) AS (
                    SELECT 0, 0, LENGTH(strippedvalue)
                    UNION ALL
                    SELECT 
                        substr(strippedvalue, i, 1),
                        IIF(
                            substr(strippedvalue, i-1, 1) * 2 > 9, 
                            substr(strippedvalue, i-1, 1) * 2 - 9, 
                            substr(strippedvalue, i-1, 1) * 2
                        ),
                        i - 2
                    FROM L WHERE i > 0
                 )
                SELECT SUM(digit1 + digit2) % 10 == 0 FROM L
            )
        END
    FROM stripped
)