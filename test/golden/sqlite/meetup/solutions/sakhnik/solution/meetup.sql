-- Schema: CREATE TABLE "meetup" ( "year" INTEGER, "month" INTEGER, "week" TEXT, "dayofweek" TEXT, "result" TEXT);
-- Task: update the meetup table and set the result based on the other fields.

with
  -- Decode weekday into number
  day_name(day_number, day_name) as
    (select 1, 'Monday' union
     select 2, 'Tuesday' union
     select 3, 'Wednesday' union
     select 4, 'Thursday' union
     select 5, 'Friday' union
     select 6, 'Saturday' union
     select 7, 'Sunday'),
  -- Collect month features: first day of week, target day of week (given), count of days in the month
  features(id, first_dow, target_dow, month_days) as
    (select rowid,
            cast(strftime('%w', printf('%d-%02d-01', year, month)) as int),
            day_name.day_number,
            julianday(date(printf('%d-%02d-01', year, month), '+1 month')) - julianday(date(printf('%d-%02d-01', year, month)))
     from meetup, day_name
     where day_name.day_name = meetup.dayofweek),
  -- Calculate the day number corresponding to the required day of week
  first_day_offset(id, day, month_days) as
    (select id, 1 + iif(target_dow < first_dow, 7 + target_dow - first_dow, target_dow - first_dow), month_days from features),
  -- Calculate the day number for the required week
  calc_day(id, day) as
    (select id, case meetup.week
       when 'first' then day
       when 'second' then day + 7
       when 'third' then day + 14
       when 'fourth' then day + 21
       when 'last' then iif(day + 28 <= month_days, day + 28, iif(day + 21 <= month_days, day + 21, day + 14))
       when 'teenth' then iif(day + 14 >= 13 and day + 14 <= 19, day + 14, day + 7)
     end
     from first_day_offset, meetup
     where meetup.rowid = first_day_offset.id)
-- Format the result
update meetup
set result = printf('%d-%02d-%02d', year, month, day)
from calc_day where rowid = id;
