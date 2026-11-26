-module(dominoes).

-export([can_chain/1]).

can_chain([]) -> true;
can_chain([{A,B}|[]]) when A == B -> true;
can_chain([{A,B}|Dominoes]) ->
    lists:any(fun({NextA,NextB}) when NextA == B -> can_chain([{A,NextB} | Dominoes -- [{NextA,NextB}]]);
                 ({NextA,NextB}) when NextB == B -> can_chain([{A,NextA} | Dominoes -- [{NextA,NextB}]]);
                  (_) -> false end, Dominoes).