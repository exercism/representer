-- This version delegates the transcription to the "tr" program, which avoids the 
-- slightly horrible nested replace calls that seem to be required in a fully
-- SQLite solution

-- Output input data to a file
.mode csv
.once input.txt
SELECT dna FROM "rna-transcription";

-- Cleanup new lines in the file, converting \r\n to just \n
--  otherwise the later steps see these are multiple lines
.shell cat input.txt | tr -d '\\r' > cleaned-input.txt

-- Transcribe the DNA from the cleaned input file
.shell cat cleaned-input.txt | tr GCTA CGAU > transcribed.txt

-- Combine the columns of the cleaned input data and the transcribed into a CSV file
.shell paste -d , cleaned-input.txt transcribed.txt > combined.csv

-- Replace the data in the original table with the data from the CSV file
DELETE FROM "rna-transcription";
.import --csv combined.csv "rna-transcription"
