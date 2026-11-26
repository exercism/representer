-module(darts).

-export([score/2]).

distance(X,Y) -> math:sqrt(math:pow(X, 2) + math:pow(Y, 2)).

score(X, Y) -> 
  case distance(X,Y) of
    Dist when Dist > 10 -> 0; 
    Dist when Dist > 5 -> 1;
    Dist when Dist > 1 -> 5;
    _ -> 10
  end.
