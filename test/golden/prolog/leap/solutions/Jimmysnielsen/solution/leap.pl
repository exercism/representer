use_module(library(clpfd)).

leap(Year) :-
    0 is Year mod 4, not(0 is Year mod 100);
    0 is Year mod 400.

