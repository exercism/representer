UPDATE leap
SET is_leap = CASE 
    WHEN year % 4 = 0 AND (year % 100 != 0 OR year % 400 = 0) THEN 1 
    ELSE 0 
END;