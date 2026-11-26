-- Schema: CREATE TABLE "leap" ( "year" INT, "is_leap" BOOL);
-- Task: update the leap table and set the is_leap based on the year field.
update leap
set is_leap =
    case
        when year % 400 = 0 then TRUE
        when year % 100 = 0 then FALSE
        when year % 4 = 0 then TRUE
        else FALSE
        end;