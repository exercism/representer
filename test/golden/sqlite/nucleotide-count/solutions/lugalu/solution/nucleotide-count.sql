-- Task:  - Update the "nucleotide-count" table and set the result based on the input field.
--        - Update table creation with constraints.

DROP TABLE IF EXISTS "nucleotide-count";

CREATE TABLE "nucleotide-count" (
    "strand" TEXT,
    "result" TEXT,
    CHECK(strand REGEXP '^[ACGT]*$')
    );

-- Please don't change the following two import lines. Feel free to edit the previous lines, though.
.mode csv
.import ./data.csv "nucleotide-count"

-- Write your code below. Feel free to edit the CREATE TABLE above, too!

WITH countChar AS (
    SELECT
        strand as strand,
        (LENGTH(strand) - LENGTH(REPLACE(strand, 'A', '')))  as A_count,
        (LENGTH(strand) - LENGTH(REPLACE(strand, 'C', '')))  as C_count,
        (LENGTH(strand) - LENGTH(REPLACE(strand, 'T', '')))  as T_count,
        (LENGTH(strand) - LENGTH(REPLACE(strand, 'G', '')))  as G_count
    FROM 'nucleotide-count'
)

UPDATE "nucleotide-count"
set result = json_object(
    'A', A_count,
    "C", C_count,
    "G", G_count,
    "T", T_count
)
FROM countChar
WHERE countChar.strand = 'nucleotide-count'.strand;

