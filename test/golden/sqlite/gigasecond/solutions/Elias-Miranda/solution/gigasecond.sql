-- Schema: CREATE TABLE "gigasecond" ("moment" TEXT, "result" TEXT);
-- Task: update the gigasecond table and set the result based on the moment.
UPDATE gigasecond
SET result = REPLACE(DATETIME(CASE
                               WHEN LENGTH(moment) = 10 THEN moment || ' 00:00:00'
                               ELSE moment
                              END, '+1000000000 seconds'), ' ', 'T');
SELECT * FROM gigasecond;