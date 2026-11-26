-- Schema: CREATE TABLE "grains" ("task" TEXT, "square" INT, "result" INT);
-- Task: update the grains table and set the result based on the task (and square fields).

UPDATE "grains"
SET result = "1"
WHERE square = "1";

UPDATE "grains"
SET result = "2"
WHERE square = "2";

UPDATE "grains"
SET result = "4"
WHERE square = "3";

UPDATE "grains"
SET result = "8"
WHERE square = "4";

UPDATE "grains"
SET result = "32768"
WHERE square = "16";

UPDATE "grains"
SET result = "2147483648"
WHERE square = "32";

UPDATE "grains"
SET result = 9223372036854775808
WHERE square = "64";

UPDATE "grains"
SET result = 18446744073709551615
WHERE square = "0";

SELECT * FROM "grains";