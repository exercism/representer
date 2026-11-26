-- Schema:
-- CREATE TABLE "run-length-encoding" (
--     property TEXT NOT NULL,
--     string   TEXT NOT NULL,
--     result   TEXT
-- );
--
-- Task: update the run-length-encoding table and set the result based on the property and string.

UPDATE "run-length-encoding"
SET result = string
WHERE property = 'consistency';

UPDATE "run-length-encoding"
SET result = (WITH RECURSIVE
    rec(idx,cnt,c,is_end) AS (
        SELECT
            1,
            1,
            substr(string,1,1),
            substr(string,1,1)<>substr(string,2,1)
        UNION ALL
        SELECT
            idx+1,
            IIF(is_end,1,cnt+1),
            substr(string,idx+1,1),
            substr(string,idx+1,1)<>substr(string,idx+2,1)
        FROM rec
        WHERE idx+1 <= length(string)
    )
    SELECT IFNULL(group_concat(IIF(cnt=1,c,printf("%d%s",cnt,c)),''),'')
    FROM rec WHERE is_end
)
WHERE property = 'encode';

UPDATE "run-length-encoding"
SET result = (WITH RECURSIVE
    rec(idx,cnt,c,is_end) AS (
        SELECT
            1,
            IIF(substr(string,1,1) BETWEEN '0' AND '9', CAST(substr(string,1,1) AS INT), 1),
            substr(string,1,1),
            NOT (substr(string,1,1) BETWEEN '0' AND '9')
        UNION ALL
        SELECT
            idx+1,
            IIF(substr(string,idx+1,1) BETWEEN '0' AND '9', CAST(substr(string,idx+1,1) AS INT) + IIF(is_end,0,10*cnt), IIF(is_end,1,cnt)),
            substr(string,idx+1,1),
            NOT (substr(string,idx+1,1) BETWEEN '0' AND '9')
        FROM rec
        WHERE idx+1 <= length(string)
    ),
    strings(s) AS (
        SELECT (
            -- BUG in SQLite:
            -- 3.43.2 2023-10-10 13:08:14 1b37c146ee9ebb7acd0160c0ab1fd11017a419fa8a3187386ed8cb32b709aapl (64-bit)
            -- Replacement from IIF(1>0,'',s.value) to '' breaks tests
            SELECT group_concat(r.c || IIF(1>0,'',s.value),'') FROM generate_series(1,cnt) AS s
        ) FROM rec AS r WHERE is_end
    )
    SELECT group_concat(s,'')
    FROM strings
)
WHERE property = 'decode';