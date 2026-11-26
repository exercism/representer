-- Create allergen_values table
DROP TABLE IF EXISTS allergen_values;
CREATE TABLE allergen_values (
       allergen TEXT,
       value INT
);

-- Insert values
INSERT INTO allergen_values (allergen, value)
VALUES
    ('eggs', 1),
    ('peanuts', 2),
    ('shellfish', 4),
    ('strawberries', 8),
    ('tomatoes', 16),
    ('chocolate', 32),
    ('pollen', 64),
    ('cats', 128);

-- Update 'allergicTo' tasks
UPDATE allergies
SET result = CASE
    WHEN (score & ~(
         SELECT value
         FROM allergen_values
         WHERE allergen = allergies.item)) = score THEN 'false'
    ELSE 'true'
END
WHERE task = 'allergicTo';

-- Update 'list' tasks
UPDATE allergies
SET result = COALESCE(
    (
        SELECT GROUP_CONCAT(allergen, ', ')
        FROM allergen_values
        WHERE value & allergies.score != 0
    ), ''
)
WHERE task = 'list';
