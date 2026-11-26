real((A,_), A) :- number(A).
imaginary((_,B), B) :- number(B).

sq(X,X2) :- X2 is X*X.

conjugate((A,B), (A,Bneg)) :-
    Bneg is B * -1.

abs((A,B), Abs) :-
    sq(A,A2), sq(B,B2),
    Z is A2 + B2,
    sqrt(Z, Abs).

add((A,B), (C,D), (E,F)) :-
    E is A + C,
    F is B + D.

sub((A,B), (C,D), (E,F)) :-
    E is A - C,
    F is B - D.

mul((A,B), (C,D), (E,F)) :-
    E is A*C - B*D,
    F is (B*C + A*D).

div((A,B), (C,D), (E,F)) :-
    sq(C, C2), sq(D,D2),
    E is (A*C + B*D) / (C2 + D2),
    F is (B*C - A*D) / (C2 + D2).

