ALTER TABLE "matching-brackets"
ADD brackets TEXT DEFAULT '';

-- Remove any matched bracket pairs from the brackets column
PRAGMA recursive_triggers = ON;
CREATE TRIGGER IF NOT EXISTS strip_matched_brackets
    AFTER UPDATE
    ON "matching-brackets"
    WHEN NEW.brackets != OLD.brackets
BEGIN
    UPDATE "matching-brackets"
    SET brackets = REPLACE(REPLACE(REPLACE(brackets, '()', ''), '[]', ''), '{}', '')
    WHERE brackets = NEW.brackets;
END;

-- Update the brackets column to include only unpaired brackets
UPDATE "matching-brackets"
SET brackets = (
    WITH all_characters(n) AS (
        SELECT 1
        UNION ALL
        SELECT n + 1 FROM all_characters WHERE n <= LENGTH(input)
    )
    -- Select only the characters that are brackets
    SELECT group_concat(SUBSTR(input, n, 1), '')
    FROM all_characters
    WHERE '()[]{}' LIKE ('%' || SUBSTR(input, n, 1) || '%')
);

UPDATE "matching-brackets"
SET result = (brackets = '');
