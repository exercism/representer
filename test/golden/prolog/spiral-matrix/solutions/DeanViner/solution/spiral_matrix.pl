:- table replace/4.
:- table get_coord/3.
:- table set_coord/4.

%create a list from one to N
do_list(N, L):-
  findall(Num, between(1, N, Num), L).

%create N lists of length N with every element being 0
do_2d_list(N, L) :-
  numlist(1, N, Ns),
  findall(X, (member(_, Ns), X = 0), Ls),
  findall(X, (member(_, Ns), X = Ls), L).

%replace index I of [H|T] with X and return as [H|R]
replace([_|T], 0, X, [X|T]).
replace([H|T], I, X, [H|R]) :-
    I > 0,
    I1 is I-1,
    replace(T, I1, X, R).

%%%%%%%%%%%(0, 0) is the top left for all points%%%%%%%%%%%

%get the value in the 2d array at the given point
get_coord(Point, Rows, Val) :-
    Point = (X, Y),
    Rows = [H|T],
    H = [X1|Rest],
    (
    	Y == 0 ->
    		(
            	X == 0 ->  Val is X1;
            	(
                	NewX is X - 1,
                    get_coord((NewX, Y), [Rest], Val)
                )
            );
    	(
        	NewY is Y - 1,
            get_coord((X, NewY), T, Val)
        )
    ).

%set the value of the 2d array to val at the given point and give it back as NewRows
set_coord(Point, Rows, Val, NewRows) :-
    Point = (X, Y),
    Rows = [H|T],
    (
    	Y == 0 ->
    		(
            	replace(H, X, Val, NewRow),
                NewRows = [NewRow|T]
            );
    	(
        	NewY is Y - 1,
            set_coord((X, NewY), T, Val, NewTail),
            NewRows = [H|NewTail]
        )
    ).

%given a point and a direction(00-right,1-down,2-left,3-up)
%give the next point and a direction to use should the point be invalid
get_next_point(Point, Direction, NextPoint, Direction2) :-
    Point = (X, Y),
    (
    	Direction == 0 ->
    		(   
            	NewX is X + 1,
                NewY is Y
            );
    	Direction == 1 ->
    		(
        		NewX is X,
                NewY is Y + 1
            );
    	Direction == 2 ->
    		(   
            	NewX is X - 1,
                NewY is Y
            );
    	Direction == 3 ->
    		(
            	NewX is X,
                NewY is Y - 1
            )
    ),
    DirSum is Direction + 1,
    Direction2 is mod(DirSum, 4),
    NextPoint = (NewX, NewY).

%this is the engine that traverses the 2d array in a spiral and sets the values
turtle(_, [], Rows, _, _, FinalRows) :-
    FinalRows = Rows.
turtle(Size, Nums, Rows, Direction, Point, FinalRows) :-
    Nums = [H|T],
    set_coord(Point, Rows, H, NewRows),
    get_next_point(Point, Direction, NextPoint, Direction2),
    (
    	(get_coord(NextPoint, NewRows, Val), Val == 0) ->  
    		turtle(Size, T, NewRows, Direction, NextPoint, IntermediateRows);
    	(   
        	get_next_point(Point, Direction2, OtherNextPoint, Direction3),
            DirSum is Direction2 + 1,
    		Direction3 is mod(DirSum, 4),
            turtle(Size, T, NewRows, Direction2, OtherNextPoint, IntermediateRows)
        )
    ),
    FinalRows = IntermediateRows.

%the spiral rule
spiral(Size, Rows) :-
    Size is 0 ->  Rows = [];
    do_2d_list(Size, EmptyList),
    Area is Size**2,
    do_list(Area, Nums),
    turtle(Size, Nums, EmptyList, 0, (0,0), Rows).