-- Schema: CREATE TABLE "bob" ("input" TEXT, "reply" TEXT);
-- Task: update the bob table and set the reply based on the input.
UPDATE bob
SET reply =
    CASE 
        WHEN TRIM(input) LIKE '%?' AND TRIM(input) REGEXP '^[^a-z]*$' AND TRIM(input) REGEXP '[A-Z]' THEN "Calm down, I know what I'm doing!" 
        WHEN TRIM(input) LIKE '%?' THEN "Sure."
        WHEN TRIM(input) REGEXP '^[^a-z]*$' AND TRIM(input) REGEXP '[A-Z]' THEN "Whoa, chill out!" 
        WHEN TRIM(REPLACE(REPLACE(REPLACE(input, CHAR(9), ''), CHAR(10), ''), CHAR(14), '')) = '' THEN "Fine. Be that way!"
        ELSE "Whatever."
    END