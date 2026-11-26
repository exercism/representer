:- use_module(library(clpfd)).

% create an array
array(Len, Arr) :-
    length(Arr, Len).
% assign Arr[Idx] = Val
index(Arr, Idx, Val) :-
    X =.. [arr|Arr],
    arg(Idx, X, Val).

% create a matrix
matrix(0, _, []) :- !.
matrix(Hgt, Wth, Mx) :-
    array(Wth, Front),
    succ(Sub, Hgt),
    matrix(Sub, Wth, Back),
    Mx = [Front|Back].
% assign Mx[I,J] = Val
index(Mx, I, J, Val) :-
    index(Mx, I, Line),
    index(Line, J, Val).

% go around the matrix in a spiral
% end case: filled N² indexes
spiral(_, _, Cnt, Stop, _) :-
    succ(Stop, Cnt), !.
% default case: go straight and put value of counter in index
spiral((I,J), (IDir,JDir), Cnt, Stop, Spi) :-
    INext #= I + IDir,
    JNext #= J + JDir,
    index(Spi, INext, JNext, Cnt),
    succ(Cnt, CntNext),
    spiral((INext,JNext), (IDir,JDir), CntNext, Stop, Spi), !.
% in case out of bounds or already filled, turn 90 degrees
spiral(Pos, (IDir,JDir), Cnt, Stop, Spi) :-
    IDirNext = JDir,
    JDirNext #= -IDir,
    spiral(Pos, (IDirNext,JDirNext), Cnt, Stop, Spi), !.

spiral(N, Spi) :-
    matrix(N, N, Spi),
    NSq #= N / N,
    spiral((1,0), (0,1), 1, NSq, Spi), !.
