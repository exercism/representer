-module(isogram).

-export([is_isogram/1]).

-compile([debug_info]).

is_isogram(_Phrase) -> 
    _P = lists:filtermap(
            fun(X) ->
                    I = string:to_lower(X),
                    case I >= $a andalso I =< $z of 
                        true -> {true, I};
                        _ -> false
                    end
            end,
            _Phrase),
    length(_P) =:= length(lists:usort(_P)).
