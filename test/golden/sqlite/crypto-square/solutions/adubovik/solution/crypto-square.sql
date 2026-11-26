-- Schema:
-- CREATE TABLE "crypto-square" (
--   plaintext TEXT NOT NULL,
--   result    TEXT
-- );
--
-- Task: update the crypto-square table and set the result column based on the plaintext.

UPDATE "crypto-square"
SET result = (WITH
    text_arr(c) AS (
        SELECT lower(substr(plaintext, value, 1))
        FROM generate_series(1, length(plaintext))
        WHERE substr(plaintext, value, 1) GLOB '[0-9a-zA-Z]'
    ),
    norm(s) AS (SELECT IFNULL(group_concat(c,''),'') FROM text_arr),
    lom(n) AS (SELECT length(s) FROM norm),
    c(n) AS (SELECT ceiling(sqrt(n)) FROM lom),
    r0(n) AS (SELECT floor(sqrt(n)) FROM lom),
    r(n) AS (SELECT IIF(r0.n*c.n>=lom.n,r0.n,r0.n+1) FROM lom, r0, c),
    coded_line(s) AS (
        SELECT group_concat(
            IFNULL(NULLIF(substr(norm.s, i.value*c.n + j.value + 1, 1), ''), ' '),
        '')
        FROM
            r, generate_series(0,r.n-1) AS i,
            c, generate_series(0,c.n-1) AS j,
            norm
        GROUP BY j.value
        ORDER BY j.value
    )
    SELECT IFNULL(group_concat(s,' '),'') FROM coded_line
);