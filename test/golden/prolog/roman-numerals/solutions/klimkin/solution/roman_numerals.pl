convert(Decimal, Roman) :-
    decimal_to_roman([
        (1000, "M"), (900, "CM"), (500, "D"), (400, "CD"),
        (100,  "C"), (90,  "XC"), (50,  "L"), (40,  "XL"),
        (10,   "X"), (9,   "IX"), (5,   "V"), (4,   "IV"),
        (1,    "I")
    ], Decimal, Roman).
convert(0, "").

decimal_to_roman([(Value, Symbols)|T], Decimal, Roman) :-
    Decimal >= Value ->
    N1 is Decimal - Value,
    decimal_to_roman([(Value, Symbols)|T], N1, Numeral1),
    atomics_to_string([Symbols, Numeral1], Roman),
    !.
decimal_to_roman([_|T], Decimal, Roman) :-
    decimal_to_roman(T, Decimal, Roman).
decimal_to_roman([], 0, "").
