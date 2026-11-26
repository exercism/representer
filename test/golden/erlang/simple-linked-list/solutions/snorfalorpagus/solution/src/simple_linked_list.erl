-module(simple_linked_list).

-export([
    cons/2,
    count/1,
    empty/0,
    from_native_list/1,
    head/1,
    reverse/1,
    tail/1,
    to_native_list/1
]).

empty() -> terminator.

cons(Elt, List) -> {Elt, List}.

head({Head, _Tail}) -> Head.

tail({_Head, Tail}) -> Tail.

reverse(List) -> reverse(List, terminator).
reverse(terminator, Acc) -> Acc;
reverse({Head, Tail}, Acc) -> reverse(Tail, {Head, Acc}).

count(List) -> count(List, 0).
count(terminator, Acc) -> Acc;
count({_Head, Tail}, Acc) -> count(Tail, Acc + 1).

to_native_list(terminator) -> [];
to_native_list({Head, Tail}) -> [Head | to_native_list(Tail)].

from_native_list(NativeList) ->
    lists:foldl(fun(Elt, List) -> {Elt, List} end, terminator, lists:reverse(NativeList)).
