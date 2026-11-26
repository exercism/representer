-module(clock).

-export([create/2, is_equal/2, minutes_add/2, to_string/1]).


create(Hour, Minute) -> 
    {NormalizedMinute, AddedHours} = 
            if 
                Minute >= 0 -> {Minute rem 60, Minute div 60};
                Minute < 0 -> RemainderMinutes = (Minute rem 60), 
                             if 
                                RemainderMinutes =/= 0 -> { 60 + RemainderMinutes, -1 + (Minute div 60)};
                                true-> {RemainderMinutes , (Minute div 60)}
                             end   
            end,
    SummaryHour = Hour + AddedHours,        
    NormalizedHour = 
            if 
                SummaryHour >= 0 -> SummaryHour rem 24;
                SummaryHour < 0 -> Reminder = (SummaryHour rem 24), 
                                  if Reminder=/=0 -> 24 + Reminder;
                                     true -> 0
                                  end   
             end,
             
    {NormalizedHour, NormalizedMinute}.

is_equal({Hour, Minute}, {Hour, Minute}) -> true;
is_equal(_, _) -> false.


minutes_add({Hour, CurrMinutes}, Minutes) -> create(Hour, CurrMinutes+Minutes).

to_string({Hour, Minute}) -> io_lib:format("~2..0B:~2..0B", [Hour,Minute]).
