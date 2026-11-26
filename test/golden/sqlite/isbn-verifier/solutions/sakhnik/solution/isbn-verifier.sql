-- Schema: CREATE TABLE "isbn-verifier" (isbn TEXT NOT NULL, result BOOL);
-- Task: update the isbn-verifier table and set the result based on the isbn.

UPDATE "isbn-verifier"
SET result = (
    WITH
        -- Step 1: normalize by stripping dashes
        normalized(val) AS (
            SELECT REPLACE(isbn, '-', '')
        ),

        -- Step 2: expand into digits with weights
        digits(pos, digit, weight) AS (
            SELECT 1, CAST(SUBSTR(val, 1, 1) AS INTEGER), 10 FROM normalized
            UNION ALL
            SELECT pos+1,
                   CASE 
                       WHEN pos+1 = 10 AND SUBSTR(val, 10, 1) = 'X' 
                           THEN 10
                       ELSE CAST(SUBSTR(val, pos+1, 1) AS INTEGER)
                   END,
                   10 - pos
            FROM digits, normalized
            WHERE pos < 10
        ),

        -- Step 3: compute checksum
        checksum(sum) AS (
            SELECT SUM(digit * weight) FROM digits
        )

    SELECT CASE 
               WHEN val REGEXP '^[0-9]{9}[0-9X]$'
                    AND (SELECT sum FROM checksum) % 11 = 0
               THEN 1
               ELSE 0
           END
    FROM normalized
);
