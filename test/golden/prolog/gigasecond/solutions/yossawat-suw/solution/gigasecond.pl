:- use_module(library(date_time)).

add_gigasecond(Date, GigasecondDate) :-
    Gigasecond is 1_000_000_000,
    date_time_stamp(Date, Timestamp),
    NewTimestamp is Timestamp + Gigasecond,
    stamp_date_time(NewTimestamp, GigasecondDate, 'UTC').