-module(spiral_matrix).

-export([make/1]).


setRow(_, [], Matrix, _) -> Matrix;
setRow(Row, [ V | T ], Matrix, FromCol) ->
    setRow(Row, T, maps:put({Row, FromCol}, V, Matrix), FromCol+1).

setCol(_, [], Matrix, _) -> Matrix;
setCol(Col, [ V | T ], Matrix, FromRow) ->
    setCol(Col, T, maps:put({FromRow, Col}, V, Matrix), FromRow+1).
    
make(Size) ->
    Matrix = make(Size, 0, 1, maps:new()),
    lists:map(fun(R) ->
        lists:map(fun(C) ->
            maps:get({R,C}, Matrix)
        end, lists:seq(1,Size))
    end, lists:seq(1,Size)).

make(Size, _Offset, _From, Matrix) when Size == 0 -> Matrix;
make(Size, Offset, From, Matrix) when Size == 1 ->
    maps:put({1+Offset, 1+Offset}, From, Matrix);
make(Size, Offset, From, Matrix) ->
    M1 = setRow(1-Offset, lists:seq(From, From+Size-1), Matrix, 1+Offset),
    M2 = setCol(Size+Offset, lists:seq(From+Size, From+2*Size-2), M1, 2+Offset),
    M3 = setRow(Size+Offset, lists:seq(From+3*Size-3, From+2*Size-2, -1), M2, 1+Offset),
    M4 = setCol(1+Offset, lists:seq(From+4*Size-5, From+3*Size-2, -1), M3, 2+Offset),
    make(Size-2, Offset+1, From+4*Size-4, M4).