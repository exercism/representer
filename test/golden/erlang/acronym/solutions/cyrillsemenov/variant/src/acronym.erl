-module(acronym).

-export([abbreviate/2]).

abbreviate(_Phrase) ->
    lists:flatten(
        lists:map(
            fun(X) ->
                [FirstChar | _] = X,
                string:to_upper(FirstChar)
            end,
            string:tokens(_Phrase, " -_")
        )
    ).
