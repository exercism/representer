-- Schema:
-- CREATE TABLE "grade-school" (
--   property TEXT NOT NULL,
--   input    TEXT NOT NULL,    -- json object
--   result   TEXT              -- json array
-- );
--
-- Task: update the grade-school and update the result column based on the property and the input.


WITH students AS (
    SELECT 
        value->>'$[0]' AS name,
        FIRST_VALUE(value->>'$[1]') OVER (PARTITION BY value->>'$[0]') AS grade
    FROM json_each(input, '$.students')
    ORDER BY grade, name
)

UPDATE "grade-school"
SET result = CASE property
    WHEN 'add' THEN (
        SELECT json_group_array(json(IIF(st_count = 2, 'true', 'false')))
        FROM (
            SELECT ROW_NUMBER() OVER (PARTITION BY name) AS st_count
            FROM students)
        ) 
    ELSE (
        SELECT json_group_array(name)
        FROM (
            SELECT DISTINCT name
            FROM students
            WHERE grade = IIF(property='roster', grade, input->>'$.desiredGrade'))
        )
    END;