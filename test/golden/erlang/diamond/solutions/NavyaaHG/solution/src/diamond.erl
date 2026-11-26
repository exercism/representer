-module(diamond).

-export([rows/1]).


rows([Letter]) ->
	Size = (Letter - $A) * 2 + 1,
	Middle = (Size + 1) div 2,
	F_generator =
	fun(Row, Acc) ->
		Offset = Middle - abs(Middle - Row) - 1,
		CurrentLetter = $A + Offset,
		F_generator_row =
		fun(Column, RowAcc) ->
			if
				abs(Column - Middle) == Offset ->
					[CurrentLetter|RowAcc];
				true ->
					[$ |RowAcc]
			end
		end,
		[lists:foldl(F_generator_row, [], lists:seq(1, Size))|Acc]
	end,
	lists:foldl(F_generator, [], lists:seq(1, Size)).