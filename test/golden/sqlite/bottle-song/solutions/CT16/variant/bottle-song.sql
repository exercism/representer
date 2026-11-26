-- Schema:
-- CREATE TABLE "bottle-song" (
--         start_bottles INTEGER NOT NULL,
--         take_down     INTEGER NOT NULL,
--         result        TEXT
-- );
-- Task: update bottle-song table and set the result based on the
-- start_bottles and take_down.
WITH RECURSIVE verse_numbers(row_id, n, start_bottles, take_down) AS (
    SELECT rowid, start_bottles, start_bottles, take_down
    FROM "bottle-song"
    UNION ALL
    SELECT row_id, n - 1, start_bottles, take_down
    FROM verse_numbers
    WHERE n > start_bottles - take_down + 1
)
, verses(row_id, verse_text, n) AS (
    SELECT
        row_id,
        (CASE WHEN n=10 THEN 'Ten' WHEN n=9 THEN 'Nine' WHEN n=8 THEN 'Eight'
              WHEN n=7 THEN 'Seven' WHEN n=6 THEN 'Six' WHEN n=5 THEN 'Five'
              WHEN n=4 THEN 'Four' WHEN n=3 THEN 'Three' WHEN n=2 THEN 'Two'
              WHEN n=1 THEN 'One' END)
        || ' green ' || (CASE WHEN n=1 THEN 'bottle' ELSE 'bottles' END)
        || ' hanging on the wall,' || CHAR(10) ||
        (CASE WHEN n=10 THEN 'Ten' WHEN n=9 THEN 'Nine' WHEN n=8 THEN 'Eight'
              WHEN n=7 THEN 'Seven' WHEN n=6 THEN 'Six' WHEN n=5 THEN 'Five'
              WHEN n=4 THEN 'Four' WHEN n=3 THEN 'Three' WHEN n=2 THEN 'Two'
              WHEN n=1 THEN 'One' END)
        || ' green ' || (CASE WHEN n=1 THEN 'bottle' ELSE 'bottles' END)
        || ' hanging on the wall,' || CHAR(10) ||
        'And if one green bottle should accidentally fall,' || CHAR(10) ||
        'There''ll be ' ||
        (CASE WHEN n-1=9 THEN 'nine' WHEN n-1=8 THEN 'eight' WHEN n-1=7 THEN 'seven'
              WHEN n-1=6 THEN 'six' WHEN n-1=5 THEN 'five' WHEN n+1=4 THEN 'four'
              WHEN n-1=3 THEN 'three' WHEN n-1=2 THEN 'two' WHEN n-1=1 THEN 'one'
              WHEN n-1=0 THEN 'no' END)
        || ' green ' || (CASE WHEN n-1=1 THEN 'bottle' ELSE 'bottles' END)
        || ' hanging on the wall.',
        n
    FROM verse_numbers
)
UPDATE "bottle-song"
SET result = (
    SELECT GROUP_CONCAT(verse_text, CHAR(10) || CHAR(10) ORDER BY n DESC)
    FROM verses
    WHERE verses.row_id = "bottle-song".rowid
);