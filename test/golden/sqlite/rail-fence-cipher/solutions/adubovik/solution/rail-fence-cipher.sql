-- Schema:
-- CREATE TABLE "rail-fence-cipher" (
--   property TEXT    NOT NULL,
--   msg      TEXT    NOT NULL,
--   rails    INTEGER NOT NULL,
--   result   text
-- );
--
-- Task: update the rail-fence-cipher table and set the result column based on the property, the msg and the rails.

UPDATE "rail-fence-cipher"
SET result = (WITH
    dirs(col_idx,row_idx,dir,chr) AS (
        SELECT 1,1,1,substr(msg,1,1)
        UNION ALL
        SELECT
            col_idx+1,
            IIF(row_idx+dir BETWEEN 1 AND rails, row_idx+dir, row_idx-dir),
            IIF(row_idx+dir BETWEEN 1 AND rails, dir, -dir),
            substr(msg,col_idx+1,1)
        FROM dirs
        WHERE col_idx+1 <= length(msg)
    ),
    dirs_sorted(col_idx,chr,rev_col_idx) AS (
        SELECT col_idx, chr, ROW_NUMBER() OVER (ORDER BY row_idx, col_idx)
        FROM dirs
        ORDER BY row_idx, col_idx
    ),
    encoded(s) AS (
        SELECT group_concat(chr,'') FROM dirs_sorted
    ),
    decoded(s) AS (
        SELECT group_concat(substr(msg,rev_col_idx,1),'')
        FROM (SELECT * FROM dirs_sorted ORDER BY col_idx)
    )
    SELECT IIF(property='encode', (SELECT s FROM encoded), (SELECT s FROM decoded))
);