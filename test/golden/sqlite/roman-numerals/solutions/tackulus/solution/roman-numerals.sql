-- Schema: CREATE TABLE "roman-numerals" ("number" INT, "result" TEXT);
-- Task: update the roman-numerals table and set the result based on the number.

WITH mapping (arabic, roman) AS (
    VALUES (1000, 'M'), (900, 'CM'), (500, 'D'), (400, 'CD'), 
        (100, 'C'), (90, 'XC'), (50, 'L'), (40, 'XL'),
        (10, 'X'), (9, 'IX'), (5, 'V'), (4, 'IV'), (1, 'I')
)
UPDATE "roman-numerals" AS r
SET result = (
    WITH RECURSIVE calc (number, remaining, letters) AS (
        SELECT r.number, r.number, ''
        UNION ALL
        SELECT c.number, 
               c.remaining % m.arabic, 
               REPLACE(
                   PRINTF('%.*c', FLOOR(c.remaining / m.arabic), '@'), 
                   '@', m.roman
               )
        FROM calc AS c, mapping AS m
        WHERE c.remaining > 0 AND m.arabic = (SELECT MAX(arabic) FROM mapping WHERE arabic <= c.remaining)
    )
    SELECT GROUP_CONCAT(c.letters, '')
    FROM calc AS c
    WHERE c.number = r.number
)