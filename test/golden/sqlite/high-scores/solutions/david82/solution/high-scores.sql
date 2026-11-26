-- Schema: 
--   CREATE TABLE "scores" ("game_id" TEXT, "score" INT);
--   CREATE TABLE "results" ("game_id" TEXT, "property" TEXT, "result" TEXT);

-- Task: Given the data in the "scores" table, update the "result" field in the "results" table.

UPDATE results
SET result = CASE property
    WHEN 'scores' THEN (
        SELECT GROUP_CONCAT(score, ',')
        FROM (
            SELECT score
            FROM scores
            WHERE game_id = results.game_id
            ORDER BY rowid ASC
        )
    )
    WHEN 'latest' THEN (
        SELECT CAST(score AS TEXT)
        FROM scores
        WHERE game_id = results.game_id
        ORDER BY rowid DESC
        LIMIT 1
    )
    WHEN 'personalBest' THEN (
        SELECT CAST(MAX(score) AS TEXT)
        FROM scores
        WHERE game_id = results.game_id
    )
    WHEN 'personalTopThree' THEN (
        SELECT GROUP_CONCAT(score, ',')
        FROM (
            SELECT score
            FROM scores
            WHERE game_id = results.game_id
            ORDER BY score DESC
            LIMIT 3
        )
    )
    ELSE result
END;
