-module(pangram).

-export([is_pangram/1]).

-define(ALPHABET, "ABCDEFGHIJKLMNOPQRSTUVWXYZ").

is_pangram(Sentence) -> 
    is_panagram(filter_alpha(Sentence),?ALPHABET).

is_panagram([], []) ->
    true;
is_panagram([_Sh|_St], []) ->
    true;
is_panagram([], _Acc) ->
    false;
is_panagram([Sh|St], AlphabetReminder) ->
    case is_upper(Sh) of
        true -> ShUpper = Sh;
        false -> ShUpper = Sh-32
    end,
    is_panagram(St, AlphabetReminder -- [ShUpper]).

-spec is_upper(integer()) -> boolean().
is_upper(Letter) ->
    (Letter > 64) and (Letter < 91).

is_lower(Letter) ->
    (Letter > 96) and (Letter < 123).

filter_alpha(String) -> 
    lists:filter(fun(L) -> (is_upper(L) or is_lower(L)) end, String).