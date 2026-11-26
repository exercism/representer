square(SquareNumber, Value) :-
    SquareNumber > 0,
    SquareNumber =< 64,
    Value is 2 ** (SquareNumber - 1).

total(Value) :-
    numlist(1,64, SquareNumbers),                    % Generates cons-list
    count(SquareNumbers, 0, Value).

count([], Acc, Acc).                                 % Terminates recursion, `Value` is accumulator

count([SquareNumber|SquareNumbers], Acc, Value) :-
    square(SquareNumber, SquareValue),
    NextAcc is Acc + SquareValue,
    count(SquareNumbers, NextAcc, Value).