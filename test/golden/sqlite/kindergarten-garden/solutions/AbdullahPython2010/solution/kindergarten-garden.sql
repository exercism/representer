-- Schema: CREATE TABLE "kindergarten-garden" ("diagram" TEXT, "student" TEXT, "result" TEXT);
-- Task: update the kindergarten-garden table and set the result based on the diagram and student fields.
WITH student_positions AS (
    -- Lista de estudiantes en orden alfabético, con su posición (0 para Alice, 1 para Bob, etc.)
    SELECT 
        'Alice' AS student, 0 AS position
    UNION ALL SELECT 'Bob', 1
    UNION ALL SELECT 'Charlie', 2
    UNION ALL SELECT 'David', 3
    UNION ALL SELECT 'Eve', 4
    UNION ALL SELECT 'Fred', 5
    UNION ALL SELECT 'Ginny', 6
    UNION ALL SELECT 'Harriet', 7
    UNION ALL SELECT 'Ileana', 8
    UNION ALL SELECT 'Joseph', 9
    UNION ALL SELECT 'Kincaid', 10
    UNION ALL SELECT 'Larry', 11
),
diagram_split AS (
    -- Dividimos el diagrama en dos filas
    SELECT 
        diagram,
        SUBSTR(diagram, 1, INSTR(diagram, CHAR(10))-1) AS row1,  -- Primera fila del diagrama
        SUBSTR(diagram, INSTR(diagram, CHAR(10))+1) AS row2      -- Segunda fila del diagrama
    FROM "kindergarten-garden"
)
-- Actualizamos la tabla "kindergarten-garden" con el resultado de las plantas de cada estudiante
UPDATE "kindergarten-garden"
SET result = (
    SELECT 
        CASE SUBSTR(ds.row1, sp.position * 2 + 1, 1)
            WHEN 'G' THEN 'grass'
            WHEN 'C' THEN 'clover'
            WHEN 'R' THEN 'radishes'
            WHEN 'V' THEN 'violets'
        END || ',' ||
        CASE SUBSTR(ds.row1, sp.position * 2 + 2, 1)
            WHEN 'G' THEN 'grass'
            WHEN 'C' THEN 'clover'
            WHEN 'R' THEN 'radishes'
            WHEN 'V' THEN 'violets'
        END || ',' ||
        CASE SUBSTR(ds.row2, sp.position * 2 + 1, 1)
            WHEN 'G' THEN 'grass'
            WHEN 'C' THEN 'clover'
            WHEN 'R' THEN 'radishes'
            WHEN 'V' THEN 'violets'
        END || ',' ||
        CASE SUBSTR(ds.row2, sp.position * 2 + 2, 1)
            WHEN 'G' THEN 'grass'
            WHEN 'C' THEN 'clover'
            WHEN 'R' THEN 'radishes'
            WHEN 'V' THEN 'violets'
        END
    FROM student_positions sp
    JOIN diagram_split ds
    ON ds.diagram = "kindergarten-garden".diagram
    WHERE sp.student = "kindergarten-garden".student
);
