-module(phone_number).
-export([number/1, areacode/1, pretty_print/1]).
-define(INVALID, "0000000000").

-spec number(string()) -> string().
number(Full_form) ->
    Reduced = lists:filter(fun is_numeric/1, Full_form),
    case length(Reduced) of
        11 -> fix_country_code(Reduced);
        10 -> Reduced;
        _ -> ?INVALID
    end.

-spec is_numeric(char()) -> boolean().
is_numeric(C) -> C >= $0 orelse C =< $9.

-spec fix_country_code(string()) -> string().
fix_country_code([$1 | Local]) -> Local;
fix_country_code(_) -> ?INVALID.

-spec areacode(string()) -> string().
areacode(Full_form) ->
    [A, B, C | _] = number(Full_form),
    [A, B, C].

-spec pretty_print(string()) -> string().
pretty_print(Full_form) ->
    case length(Full_form) of
        11 ->
            pretty_print(tl(Full_form));
        10 ->
            Numbers = [list_to_integer([C]) || C <- Full_form],
            lists:flatten(io_lib:format("(~w~w~w) ~w~w~w-~w~w~w~w", Numbers))
    end.
