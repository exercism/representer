
head([X|_],X).

ouroboros([]).
ouroboros(Chain) :-
    head(Chain,(A,_)),
    last(Chain,(_,A)).

reversed((A,B),(B,A)).

make_chain([],[]).
make_chain([(A,B)],[(A,B)]).
make_chain([(A,B)],[(B,A)]).
make_chain(Dominoes,[(A,B),(B,C)|Rest]) :-
    select((A,B),Dominoes,Dominoes1),
    make_chain(Dominoes1,[(B,C)|Rest]).
make_chain(Dominoes,[(B,A),(A,C)|Rest]) :-
    select((A,B),Dominoes,Dominoes1),
    make_chain(Dominoes1,[(A,C)|Rest]).

can_chain(Dominoes) :-
    make_chain(Dominoes,Chain),
    ouroboros(Chain).
