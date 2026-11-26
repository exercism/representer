% Handle the base case: when N is 0, return an empty list
pascal(0, []) :- !.

% Entry point: generates Pascal's triangle with N rows
pascal(N, Rows) :-
    N >= 0,
    build_triangle(N, [[1]], Rows).

% Termination condition: stop building when desired number of rows is reached
build_triangle(N, TriangleSoFar, TriangleSoFar) :-
    length(TriangleSoFar, N), !.

% Recursive case: extend the triangle by computing the next row
build_triangle(N, TriangleSoFar, FinalTriangle) :-
    last(TriangleSoFar, CurrentRow),
    next_row(CurrentRow, NewRow),
    append(TriangleSoFar, [NewRow], UpdatedTriangle),
    build_triangle(N, UpdatedTriangle, FinalTriangle).

% Construct the next row in the triangle by summing adjacent elements
next_row(PreviousRow, NewRow) :-
    shift_left(PreviousRow, LeftShifted),
    shift_right(PreviousRow, RightShifted),
    sum_lists(LeftShifted, RightShifted, NewRow).

% Prepend 0 to the beginning of the list to align for addition
shift_left(List, [0|List]).

% Append 0 to the end of the list to align for addition
shift_right(List, Result) :-
    append(List, [0], Result).

% Element-wise addition of two lists
sum_lists([], [], []).
sum_lists([A|RestA], [B|RestB], [Sum|RestSums]) :-
    Sum is A + B,
    sum_lists(RestA, RestB, RestSums).
