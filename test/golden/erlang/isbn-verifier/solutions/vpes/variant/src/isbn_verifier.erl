-module(isbn_verifier).

-export([is_valid/1]).

-spec is_valid(string()) -> boolean().
is_valid([]) -> false;
is_valid(Isbn) ->
	Input = string:to_graphemes(string:replace(Isbn, "-", "",all)),
	LengthInput = length(Input),
	case LengthInput >= 10 of
		true ->
			Zip = lists:zip(lists:seq(LengthInput,1,-1), Input),
			try lists:foldl(fun process_char/2,0,Zip) rem (LengthInput +1) of
				0 -> true;
				_ ->false
			catch
				error:{error,bad_character} -> false
			end;
		false -> false
	end.

-spec process_char({pos_integer(),term()},pos_integer())-> pos_integer().
process_char({Index,Value},Acc) when Value >= $0 andalso Value =< $9 ->  Index*(Value-$0) + Acc;
process_char({1,Value},Acc) when Value =/= $X -> io:write(paso),10 + Acc;
process_char(_,_) -> error({error,bad_character}).
