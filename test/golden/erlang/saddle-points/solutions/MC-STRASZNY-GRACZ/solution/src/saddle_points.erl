-module(saddle_points).

-export([saddle_points/1]).

saddle_points([]) -> [];
saddle_points([[] | _]) -> [];
saddle_points(Matrix) ->
	InColumn = find_lowests_in_columns(Matrix),
	InRows = find_biggests_in_rows(Matrix),
	lists:filter(fun(X) -> lists:member(X, InRows) end, InColumn).

find_lowests_in_columns(Matrix) ->
	Transposed = transpose(Matrix),
	lists:concat(lists:map(fun find_lowest_in_column/1, my_enumerate(0, Transposed))).

find_lowest_in_column({N, Column}) ->
	Lowest = lists:min(Column),
	F = fun({Pos, Elem}) ->
		case Elem of
			Lowest -> {true, {Pos, N}};
			_ -> false
		end
	end,
	lists:filtermap(F, my_enumerate(0, Column)).

find_biggests_in_rows(Matrix) ->
	lists:concat(lists:map(fun find_biggest_in_row/1, my_enumerate(0, Matrix))).

find_biggest_in_row({N, Row}) ->
	Biggest = lists:max(Row),
	F = fun({Pos, Elem}) ->
		case Elem of
			Biggest -> {true, {N, Pos}};
			_ -> false
		end
	end, 
	lists:filtermap(F, my_enumerate(0, Row)).

transpose([]) -> [];
transpose([[] | _]) -> [];
transpose(List) ->
	[lists:map(fun hd/1, List) | transpose(lists:map(fun tl/1, List))].

my_enumerate(Start, List) ->
	lists:zip(lists:seq(Start, length(List) - 1), List).


