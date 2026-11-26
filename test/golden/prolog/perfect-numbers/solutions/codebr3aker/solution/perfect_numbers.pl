divides(A,B) :- A =\= 0, (B mod A) =:= 0.

f_list(S,E,L) :- 
  ( S > E // 2   -> L=[]; 
  divides(S,E) -> L=[S|T], S1 is S+1, f_list(S1, E, T);
  S1 is S+1, f_list(S1, E, L)).

factors(N,L):- 
  (  N =:= 1 -> L=[];
  N >= 2 -> f_list(1,N,L) ).

classify(Number, Classification) :-
    factors(Number, FactorsList),
    sum_list(FactorsList, AliquotSum),
    (   (   Number == AliquotSum,
        Classification = perfect, !);
    (   Number < AliquotSum,
        Classification = abundant, !);
    (   Number > AliquotSum,
        Classification = deficient, !), !).