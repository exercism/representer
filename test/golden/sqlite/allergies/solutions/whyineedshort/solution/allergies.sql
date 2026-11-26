-- Schema: CREATE TABLE "allergies" ("task" TEXT, "item" TEXT, "score" INT NOT NULL, "result" TEXT);
-- Task: update the bob allergies and set the result based on the task.
--       - The `allergicTo` task expects `true` or `false` based on the `score` and the `item` fields.
--       - For the `list` task you have to write corresponding items to the result field
UPDATE allergies
SET result =
    CASE task
    WHEN 'allergicTo' THEN
        IIF(
            score >> CASE item
            WHEN 'eggs' THEN 0
            WHEN 'peanuts' THEN 1
            WHEN 'shellfish' THEN 2
            WHEN 'strawberries' THEN 3
            WHEN 'tomatoes' THEN 4
            WHEN 'chocolate' THEN 5
            WHEN 'pollen' THEN 6
            WHEN 'cats' THEN 7
            END & 1,
            'true', 'false'
        )
          

    WHEN 'list' THEN
        substr(
            IIF(score >> 0 & 1, ', eggs', '') ||
            IIF(score >> 1 & 1, ', peanuts', '') ||
            IIF(score >> 2 & 1, ', shellfish', '') ||
            IIF(score >> 3 & 1, ', strawberries', '') ||
            IIF(score >> 4 & 1, ', tomatoes', '') ||
            IIF(score >> 5 & 1, ', chocolate', '') ||
            IIF(score >> 6 & 1, ', pollen', '') ||
            IIF(score >> 7 & 1, ', cats', ''),
            3
        )
    END