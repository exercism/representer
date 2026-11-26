-- Task: 
--  - Drop the "nucleotide-count" table if it exists and create a new one with appropriate constraints.
--  - Populate the "result" field based on the "strand" input.

-- Drop the existing "nucleotide-count" table if it exists
DROP TABLE IF EXISTS "nucleotide-count";

-- Create the "nucleotide-count" table with constraints
CREATE TABLE "nucleotide-count" (
    "strand" TEXT,
    "result" TEXT,
    CHECK (LENGTH(REPLACE(REPLACE(REPLACE(REPLACE(strand, 'A', ''), 'C', ''), 'G', ''), 'T', '')) = 0)
);

-- Import data from CSV into the "nucleotide-count" table
.mode csv
.import ./data.csv "nucleotide-count"

-- Update the "result" field with the nucleotide counts in JSON format
UPDATE "nucleotide-count"
SET result = (
    SELECT json_object(
        'A', LENGTH(strand) - LENGTH(REPLACE(strand, 'A', '')),
        'C', LENGTH(strand) - LENGTH(REPLACE(strand, 'C', '')),
        'G', LENGTH(strand) - LENGTH(REPLACE(strand, 'G', '')),
        'T', LENGTH(strand) - LENGTH(REPLACE(strand, 'T', ''))
    )
    FROM "nucleotide-count" AS counts
    WHERE "nucleotide-count".strand = counts.strand
);

