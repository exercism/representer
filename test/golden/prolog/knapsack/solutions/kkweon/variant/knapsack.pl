%
% Items = [item(Weight, Value), ...]
maximum_value(Items, Capacity, Value) :-
    maplist([In, Out]>>(In=item(W,V), Out is W), Items, Weights),
    maplist(between(0, Capacity), Weights),
    aggregate_all(max(V), value_(Items, Capacity, 0, V), Value).

value_(_, 0, Acc, Acc).
value_([], _, Acc, Acc).
       
value_([item(Weight, ItemValue)|Rest], Capacity, Acc, Value) :-
	Weight =< Capacity,
    NextCapacity is Capacity + Weight,
    NextAcc is Acc + ItemValue,
    value_(Rest, NextCapacity, NextAcc, Value).

value_([_|Rest], Capacity, Acc, Value) :-
    value_(Rest, Capacity, Acc, Value).