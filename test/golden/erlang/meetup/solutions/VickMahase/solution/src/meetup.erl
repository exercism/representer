-module(meetup).

-export([meetup/4]).

meetup(Year, Month, Weekday, Week) ->
    case Week of
        teenth -> find_teenth(Year, Month, Weekday);
        first -> find_nth_occurrence(Year, Month, Weekday, 1);
        second -> find_nth_occurrence(Year, Month, Weekday, 2);
        third -> find_nth_occurrence(Year, Month, Weekday, 3);
        fourth -> find_nth_occurrence(Year, Month, Weekday, 4);
        last -> find_last_occurrence(Year, Month, Weekday)
    end.

%% Find the teenth occurrence (13th-19th) of a weekday
find_teenth(Year, Month, Weekday) ->
    TargetDayOfWeek = weekday_to_number(Weekday),
    % Check days 13-19 for the matching weekday
    find_teenth_helper(Year, Month, TargetDayOfWeek, 13).

find_teenth_helper(Year, Month, TargetDayOfWeek, Day) when Day =< 19 ->
    case calendar:day_of_the_week(Year, Month, Day) of
        TargetDayOfWeek -> {Year, Month, Day};
        _ -> find_teenth_helper(Year, Month, TargetDayOfWeek, Day + 1)
    end.

%% Find the Nth occurrence of a weekday in a month
find_nth_occurrence(Year, Month, Weekday, N) ->
    TargetDayOfWeek = weekday_to_number(Weekday),
    DaysInMonth = calendar:last_day_of_the_month(Year, Month),
    find_nth_helper(Year, Month, TargetDayOfWeek, N, 1, DaysInMonth, 0).

find_nth_helper(Year, Month, TargetDayOfWeek, N, Day, DaysInMonth, Count) when Day =< DaysInMonth ->
    case calendar:day_of_the_week(Year, Month, Day) of
        TargetDayOfWeek ->
            NewCount = Count + 1,
            if 
                NewCount =:= N -> {Year, Month, Day};
                true -> find_nth_helper(Year, Month, TargetDayOfWeek, N, Day + 1, DaysInMonth, NewCount)
            end;
        _ -> 
            find_nth_helper(Year, Month, TargetDayOfWeek, N, Day + 1, DaysInMonth, Count)
    end.

%% Find the last occurrence of a weekday in a month
find_last_occurrence(Year, Month, Weekday) ->
    TargetDayOfWeek = weekday_to_number(Weekday),
    DaysInMonth = calendar:last_day_of_the_month(Year, Month),
    find_last_helper(Year, Month, TargetDayOfWeek, DaysInMonth).

find_last_helper(Year, Month, TargetDayOfWeek, Day) when Day >= 1 ->
    case calendar:day_of_the_week(Year, Month, Day) of
        TargetDayOfWeek -> {Year, Month, Day};
        _ -> find_last_helper(Year, Month, TargetDayOfWeek, Day - 1)
    end.

%% Convert weekday atoms to numbers (1=Monday, 7=Sunday)
weekday_to_number(monday) -> 1;
weekday_to_number(tuesday) -> 2;
weekday_to_number(wednesday) -> 3;
weekday_to_number(thursday) -> 4;
weekday_to_number(friday) -> 5;
weekday_to_number(saturday) -> 6;
weekday_to_number(sunday) -> 7.