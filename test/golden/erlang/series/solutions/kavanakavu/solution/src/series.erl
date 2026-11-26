-module(series).

-export([slices/2]).

slices(Length, Series) ->
    case Length > length(Series) of
        true -> error(badarg);
        false -> do_slices(Length, Series)
    end.

do_slices(Length, Series) when Length > length(Series) ->
    [];
do_slices(Length, Series) ->
    [lists:sublist(Series, Length) | do_slices(Length, tl(Series))].
