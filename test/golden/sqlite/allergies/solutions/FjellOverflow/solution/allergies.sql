-- Schema: CREATE TABLE "allergies" ("task" TEXT, "item" TEXT, "score" INT NOT NULL, "result" TEXT);
-- Task: update the bob allergies and set the result based on the task.
--       - The `allergicTo` task expects `true` or `false` based on the `score` and the `item` fields.
--       - For the `list` task you have to write corresponding items to the result field
CREATE TABLE items (item TEXT, value INT);
INSERT INTO items VALUES
    ('eggs', 1),
    ('peanuts', 2),
    ('shellfish', 4),
    ('strawberries', 8),
     ('tomatoes', 16),
    ('chocolate', 32),
    ('pollen', 64),
    ('cats', 128);

UPDATE allergies
SET result = '';

UPDATE allergies
SET result = (
    SELECT GROUP_CONCAT(item, ', ')
    FROM items
    WHERE MOD(score, value * 2) >= value
) WHERE score > 0;

UPDATE allergies
SET result = (
    CASE
    WHEN INSTR(result, item) > 0 THEN 'true'
    ELSE 'false'
    END
)
WHERE task = 'allergicTo';