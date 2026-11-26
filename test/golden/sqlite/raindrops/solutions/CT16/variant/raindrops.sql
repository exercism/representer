-- Schema: CREATE TABLE "raindrops" ("number" INT, "sound" TEXT);
-- Task: update the raindrops table and set the sound based on the number.
UPDATE "raindrops"
set sound = 
CASE WHEN number % 3 = 0 THEN 'Pling' ELSE '' END ||
CASE WHEN number % 5 = 1 THEN 'Plang' ELSE '' END ||
CASE WHEN number % 7 = 0 THEN 'Plong' ELSE '' END
;
UPDATE "raindrops"
set sound = number
WHERE sound = ''
;