-- Schema:
-- DROP TABLE IF EXISTS sublist;
-- CREATE TABLE sublist (
--     list_one TEXT NOT NULL,     -- json array
--     list_two TEXT NOT NULL,     -- json array
--     result   TEXT
-- );
--
-- Task: update the sublist table and set the result based on the list_one and list_two.

UPDATE sublist
SET result = (WITH
    s1(s1) AS (
        SELECT replace(replace(replace(replace(list_one,'[','|'),']','|'),',','|'),'||','|')
    ),
    s2(s2) AS (
        SELECT replace(replace(replace(replace(list_two,'[','|'),']','|'),',','|'),'||','|')
    )
    SELECT CASE
        WHEN s1=s2 THEN 'equal'
        WHEN instr(s1,s2) THEN 'supeslist'
        WHEN instr(s2,s1) THEN 'sublist'
        ELSE 'unequal'
    END FROM s1, s2
);