-- Schema: CREATE TABLE "gigasecond" ("moment" TEXT, "result" TEXT);
-- Task: update the gigasecond table and set the result based on the moment.

-- 1 gigasecond is 1000000000

UPDATE gigasecond
SET result = strftime('%Y-%m-%dT%H:%M:%S', datetime((unixepoch(moment)+1000000000), 'unixepoch'));
--dateadd(second, 1000000000, moment);