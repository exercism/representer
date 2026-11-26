-- Schema: CREATE TABLE "matching-brackets" ("input" TEXT "result" BOOLEAN);
-- Task: update the matching-brackets table and set the result based on the input field.
INSERT INTO "matching-brackets" (input, result) VALUES
    ("[]", NULL),
    ("", NULL),
    ("[[", NULL),
    ("}{", NULL),
    ("{]", NULL),
    ("{ }", NULL),
    ("{[])", NULL),
    ("{[]}", NULL),
    ("{}[]", NULL),
    ("([{}({}[])])", NULL),
    ("{[)][]}", NULL),
    ("([{])", NULL),
    ("[({]})", NULL),
    ("[({}])", NULL),
    ("{}[", NULL),
    ("[]]", NULL),
    (")()", NULL),
    ("{)()", NULL),
    ("(((185 + 223.85) * 15) - 543)/2", NULL),
    ("\left(\begin{array}{cc} \frac{1}{3} & x\\ \mathrm{e}^{x} &... x^2 \end{array}\right)", NULL);
-- Recursive CTE to remove non-bracket characters
WITH RECURSIVE
chars(n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM chars WHERE n < LENGTH(input)
),
remove_non_brackets(input, remaining) AS (
    SELECT
        input,
        (SELECT GROUP_CONCAT(SUBSTR(input, n, 1), '') FROM chars WHERE SUBSTR(input, n, 1) IN ('(', ')', '[', ']', '{', '}'))
    FROM "matching-brackets"
),
remove_brackets(input, remaining) AS (
    SELECT
        input,
        REPLACE(REPLACE(REPLACE(remaining, '()', ''), '[]', ''), '{}', '')
    FROM remove_non_brackets
    UNION ALL
    SELECT
        input,
        REPLACE(REPLACE(REPLACE(remaining, '()', ''), '[]', ''), '{}', '')
    FROM remove_brackets
    WHERE remaining LIKE '%()%' OR remaining LIKE '%[]%' OR remaining LIKE '%{}%'
)
-- Update the result based on whether all brackets were removed
UPDATE "matching-brackets"
SET result = (
    SELECT CASE 
        WHEN input = '' THEN 1 
        WHEN remaining = '' THEN 1 
        ELSE 0 
    END
    FROM remove_brackets
    WHERE input = "matching-brackets".input
    ORDER BY LENGTH(remaining)
    LIMIT 1
);