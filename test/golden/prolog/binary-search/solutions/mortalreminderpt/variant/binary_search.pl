find(List, Value, Index) :-
    sort(List, SortedList),
    length(SortedList, Length),
    NextId is Length // 2,
    binary_search(SortedList, Value, NextId, 0, Length, Index).

binary_search(List, Value, Id, Left, Right, Target) :- 
    Id >= Left, Id < Right,
    nth0(Id, List, Num),
    (
        (Num=:=Value, Target = Id, !);
        (
            (
                (Num < Value, NextLeft is Id + 1, NextRight is Right, !);
                (Num > Value, NextRight is Id, NextLeft is Left, !)
            ),
            NextId is (NextLeft - NextRight) // 2,
            Id =\= NextId,
            binary_search(List, Value, NextId, NextLeft, NextRight, Target)
        )
    ).
    