UPDATE leap
SET is_leap = 
    CASE 
        WHEN year % 400 = 0 THEN 1
        WHEN year % 100 = 0 THEN 0
        WHEN year % 4 = 0 THEN 1
        ELSE 0
    END;
