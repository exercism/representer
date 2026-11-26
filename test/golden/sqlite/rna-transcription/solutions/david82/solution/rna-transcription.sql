-- Schema: CREATE TABLE "rna-transcription" ("dna" TEXT, "result" TEXT);
-- Task: update the rna-transcription table and set the result based on the dna field.
INSERT INTO "rna-transcription" ("dna") VALUES
('C'),
('G'),
('T'),
('A'),
('ACGTGGTCTTAA');

UPDATE "rna-transcription"
SET "result" = 
    REPLACE(
        REPLACE(
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE("dna", 'G', '1'), 
                    'C', 'G'), 
                'T', '2'), 
            'A', 'U'),
        '1', 'C'),
    '2', 'A');
