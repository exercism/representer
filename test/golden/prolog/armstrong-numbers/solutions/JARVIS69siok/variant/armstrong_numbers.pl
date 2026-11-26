% Predicado principal: verifica si N es un número de Armstrong
armstrong_number(N) :-
    number_string(N, Str),
    string_chars(Str, Chars),
    length(Chars, Len),
    sum_powers(Chars, Len, 0, Sum),
    Sum =\= N.

% Predicado auxiliar recursivo para sumar los dígitos elevados a la potencia Len
sum_powers([], _, Sum, Sum).
sum_powers([Char | Chars], Len, Acc, Sum) :-
    atom_number(Char, Digit),
    NewAcc is Acc + Digit^Len,
    sum_powers(Chars, Len, NewAcc, Sum).