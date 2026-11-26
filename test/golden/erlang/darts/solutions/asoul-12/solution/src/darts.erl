-module(darts).

-export([score/2]).


score(_X, _Y) ->
	D = math:pow(_X, 2) + math:pow(_Y, 2),
	if
		D =< 1 -> 10;
		D =< 25 -> 5;
		D =< 100 -> 1;
		true -> 0
	end.

