
leap(Year) :-
    division_remainder(Year,4,0),
(    division_remainder(Year,100,N0), dif(N0,0)
;    division_remainder(Year,400,0)
).

division_remainder(Dividend,Divisor,Remainder) :-
    Remainder is Dividend rem Divisor.
