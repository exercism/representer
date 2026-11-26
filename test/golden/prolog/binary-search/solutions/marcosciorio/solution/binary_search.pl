find(List, Target, Index) :-
    binary_search(List, Target, 0, Index).

% binary_search(+List, +Target, +Offset, -Index)
binary_search([], _, _, _) :- fail.
binary_search(List, Target, Offset, Index) :-
    length(List, Len),
    Mid is Len // 2,
    nth0(Mid, List, MidVal),
    ( Target =:= MidVal ->
        Index is Offset + Mid
    ; Target < MidVal ->
        length(Left, Mid),
        append(Left, [_|_], List),
        binary_search(Left, Target, Offset, Index)
    ; % Target > MidVal
        Mid1 is Mid + 1,
        length(Left, Mid1),
        append(Left, Right, List),
        NewOffset is Offset + Mid1,
        binary_search(Right, Target, NewOffset, Index)
    ).
