-- Schema: CREATE TABLE "leap" ( "year" INT, "is_leap" BOOL);
-- Task: update the leap table and set the is_leap based on the year field.
-- Update the leap table and set the is_leap based on the year field.
UPDATE leap
SET is_leap =
  CASE
    WHEN year % 400 = 0 THEN TRUE  -- Divisible by 400 is a leap year
    WHEN year % 100 = 0 THEN FALSE -- Divisible by 100 but not by 400 is not a leap year
    WHEN year % 4 = 0 THEN TRUE    -- Divisible by 4 but not by 100 is a leap year
    ELSE FALSE                     -- Not divisible by 4 is not a leap year
  END;