-module(minesweeper).

-export([annotate/1]).

annotate([]) -> [];
annotate([""]) -> [""];
annotate(Minefield) -> 
    MinefieldMap = input_mapifier(Minefield),
    AnnotatedMap = maps:fold(fun(Key, Value, AccMap) ->
        NewValue = case Value of
            $  -> count_mines(Key, AccMap);
            _ -> Value
        end,
        AccMap#{Key=>NewValue}
    end, MinefieldMap, MinefieldMap),
    map_stringifier(AnnotatedMap).

count_mines({R, C} = _Key, Map) ->
    case lists:foldl(fun(RowIdx, Acc) ->
        lists:foldl(fun(ColumnIdx, SubAcc) ->
            case maps:get({RowIdx, ColumnIdx}, Map, $ ) of
                $* -> SubAcc + 1;
                _ -> SubAcc
            end
        end, Acc, lists:seq(C-1, C+1))
    end, 0, lists:seq(R-1, R+1)) of
        0 -> $ ;
        Result -> Result + $0
    end.

input_mapifier(ListOfStrings) ->
    {_, FinalMap} = lists:foldl(fun(Row, {RowIdx, AccMap}) ->
        {_, SubMap} = lists:foldl(fun(Item, {ColumnIdx, SubAccMap}) ->
                        {ColumnIdx+1, SubAccMap#{{RowIdx,ColumnIdx}=>Item}}
                    end, {0, AccMap}, Row),
        {RowIdx+1, SubMap}
    end, {0, #{}}, ListOfStrings),
    FinalMap.

map_stringifier(Map) ->
    {MaxRow, MaxColumn} = lists:max(maps:keys(Map)),
    lists:foldr(fun(RowIdx, ListOfStrings) ->
        [lists:foldr(fun(ColumnIdx, String) ->
            [maps:get({RowIdx, ColumnIdx}, Map, $ ) | String]
        end, "", lists:seq(0, MaxColumn)) | ListOfStrings ]
    end, [], lists:seq(0,MaxRow)).