-- Schema:
-- CREATE TABLE "protein-translation" (
--   strand TEXT NOT NULL,
--   result TEXT         ,
--   error  TEXT
-- );
--
-- Task: update the protein-translation and set the result or the error columns based on strand.

WITH codes(triplet,acid) AS (VALUES
    ('AUG', 'Methionine'),
    ('UUU', 'Phenylalanine'),
    ('UUC', 'Phenylalanine'),
    ('UUA', 'Leucine'),
    ('UUG', 'Leucine'),
    ('UCU', 'Serine'),
    ('UCC', 'Serine'),
    ('UCA', 'Serine'),
    ('UCG', 'Serine'),
    ('UAU', 'Tyrosine'),
    ('UAC', 'Tyrosine'),
    ('UGU', 'Cysteine'),
    ('UGC', 'Cysteine'),
    ('UGG', 'Tryptophan')
)
UPDATE "protein-translation"
SET (result, error) = (WITH RECURSIVE
    aminos(rest,acid) AS (
        SELECT strand,''
        UNION ALL
        SELECT substr(rest,4), (SELECT acid FROM codes WHERE triplet = substr(rest,1,3)) FROM aminos
        WHERE
            length(rest)>0 AND
            NOT substr(rest,1,3) IN ('UAA', 'UAG', 'UGA')
    ),
    invalid(b) AS (
        SELECT COUNT(1)>0 FROM aminos WHERE acid IS NULL
    ),
    res(s) AS (
        SELECT group_concat(acid,', ') FROM aminos WHERE acid <> ''
    )
    SELECT
        IIF(invalid.b, NULL, IFNULL(res.s, '')),
        IIF(invalid.b, 'Invalid codon', NULL)
    FROM invalid, res
);