-- Schema: CREATE TABLE "color_code" ("color1" TEXT, "color2" TEXT, "result" INT);
-- Task: update the color_code table and set the result based on the two colors.

-- Step 1: Create a lookup table for color codes
CREATE TEMP TABLE IF NOT EXISTS color_values (
    color TEXT PRIMARY KEY,
    value INTEGER
);

-- Ensure we don't insert duplicates into the lookup table
INSERT OR IGNORE INTO color_values (color, value) VALUES
('black', 0),
('brown', 1),
('red', 2),
('orange', 3),
('yellow', 4),
('green', 5),
('blue', 6),
('violet', 7),
('grey', 8),
('white', 9);

-- Step 2: Enhanced Update of the color_code table using a LEFT JOIN to handle missing colors
UPDATE color_code
SET result = COALESCE(
    (SELECT a.value * 10 + b.value
     FROM color_values a
     LEFT JOIN color_values b ON color_code.color2 = b.color
     WHERE color_code.color1 = a.color), 0);

-- Verify the updates
SELECT * FROM color_code;
