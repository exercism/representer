-- Schema:
-- CREATE TABLE "binary-search" (
--   array  TEXT    NOT NULL,    -- json array
--   value  INTEGER NOT NULL,
--   result INTEGER         ,
--   error  TEXT
-- );
--
-- Task: update the binary-search table and set the result or the error columns based on the array and the value.

UPDATE "binary-search"
SET result = (WITH RECURSIVE
    tbl(idx,n) AS (
        SELECT j.key, j.value FROM json_each(array) as j
    ),
    s(idx,a,b,result) AS (
        SELECT 0, 0, (SELECT COUNT(1) FROM tbl)-1, NULL
        UNION ALL
        SELECT idx+1,
            (CASE
                WHEN (SELECT n FROM tbl where tbl.idx = (a+b)/2) < "value"
                    THEN (a+b)/2+1
                WHEN (SELECT n FROM tbl where tbl.idx = (a+b)/2) == "value"
                    THEN (a+b)/2
                ELSE
                    a
            END),
            (CASE
                WHEN (SELECT n FROM tbl where tbl.idx = (a+b)/2) < "value"
                    THEN b
                WHEN (SELECT n FROM tbl where tbl.idx = (a+b)/2) == "value"
                    THEN (a+b)/2
                ELSE
                    (a+b)/2-1
            END),
            IIF((SELECT n FROM tbl where tbl.idx = (a+b)/2) == "value", (a+b)/2, NULL)
        FROM s
        WHERE result IS NULL AND a <= b
    )
    SELECT result FROM s WHERE idx = (SELECT max(idx) FROM s)
);

UPDATE "binary-search"
SET error = "value not in array"
WHERE result IS NULL;

-- [a,b]; arr[a] <= value <= arr[b]
-- m; m < value  => (m+1,b)
--    m == value => (m,m)
--    m > value => (a,m-1)