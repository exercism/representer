-module(etl).

-export([transform/2]).


transform(Old) ->
    [{string:lowercase(Letter), Points} || {Points, Letters} <- Old, Letter <- Letters].
