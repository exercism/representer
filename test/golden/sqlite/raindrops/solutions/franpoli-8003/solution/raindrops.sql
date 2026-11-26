UPDATE raindrops
SET sound = 
    CASE WHEN number % 3 = 0 THEN 'Pling' ELSE '' END ||
    CASE WHEN number % 5 = 0 THEN 'Plang' ELSE '' END ||
    CASE WHEN number % 7 = 0 THEN 'Plong' ELSE '' END;

-- Update only if sound is empty
UPDATE raindrops
SET sound = CAST(number AS CHAR)
WHERE sound = '';
