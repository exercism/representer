-- Schema: CREATE TABLE "meetup" ( "year" INTEGER, "month" INTEGER, "week" TEXT, "dayofweek" TEXT, "result" TEXT);
-- Task: update the meetup table and set the result based on the other fields.

WITH week_lookup AS (
    SELECT 'first' AS week, 1 AS start
    UNION ALL SELECT 'second', 8
    UNION ALL SELECT 'third', 15
    UNION ALL SELECT 'fourth', 22
    UNION ALL SELECT 'fifth', 29
    UNION ALL SELECT 'teenth', 13
),
dayofweek_lookup AS (
    SELECT 'Sunday' AS dayofweek, 0 AS wday
    UNION ALL SELECT 'Monday', 1
    UNION ALL SELECT 'Tuesday', 2
    UNION ALL SELECT 'Wednesday', 3
    UNION ALL SELECT 'Thursday', 4
    UNION ALL SELECT 'Friday', 5
    UNION ALL SELECT 'Saturday', 6
),
data AS (
    SELECT
        m.year, m.month, m.week, m.dayofweek,
        CASE 
            WHEN m.week = 'last' THEN strftime('%d', m.year || printf('-%02d-01', m.month), '+1 month', '-7 days')
            ELSE w.start
        END as start,
        d.wday
    FROM meetup m
    LEFT JOIN week_lookup w ON m.week = w.week
    LEFT JOIN dayofweek_lookup d ON m.dayofweek = d.dayofweek
)

UPDATE meetup
SET result = (
    SELECT printf('%d-%02d-%02d', year, month, start + (wday - strftime('%w', year || printf('-%02d-%02d', month, start)) + 7) % 7)
    FROM data
    WHERE (data.year, data.month, data.week, data.dayofweek) = (meetup.year, meetup.month, meetup.week, meetup.dayofweek)
);
