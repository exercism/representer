leap(Year) :- 
    0 is Year mod 4, 
    Mod100 is Year mod 100,
    ( (0 is Mod100, 0 is Year mod 400), !;	not(0 is Mod100) ).
