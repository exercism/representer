-- Schema:
-- CREATE TABLE triangle (
--     property TEXT    NOT NULL,
--     side_a   REAL    NOT NULL,
--     side_b   REAL    NOT NULL,
--     side_c   REAL    NOT NULL,
--     result   BOOLEAN
-- );
--
-- Task: update the triangle and set result based on the property, side_a, side_b and side_c columns.

UPDATE triangle
SET result = IIF(side_a <= 0 OR side_b <= 0 OR side_c <= 0 OR max(side_a, side_b, side_c) > (side_a - side_b + side_c) / 2, 0,
                 CASE property
                 WHEN 'equilateral' THEN side_a == side_b AND side_b == side_c
                 WHEN 'isosceles' THEN side_a == side_b OR side_b == side_c OR side_c == side_a
                 WHEN 'scalene' THEN side_a != side_b AND side_b != side_c AND side_c != side_a
                 ELSE 0
                 END)