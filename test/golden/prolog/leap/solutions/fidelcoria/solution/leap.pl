% on every year that is evenly divisible by 4
%  except every year that is evenly divisible by 100
%    unless the year is also evenly divisible by 400

leap(Year) :-
    0 is Year mod 4,
    (   not(0 is Year mod 100)
    ;   0 is Year mod 400
    ).