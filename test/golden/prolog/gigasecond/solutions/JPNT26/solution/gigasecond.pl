add_gigasecond(Date, GigasecondDate) :-
  date_time_stamp(Date, S), T is S + 10 ^ 9,
  stamp_date_time(T, GigasecondDate, 'UTC').