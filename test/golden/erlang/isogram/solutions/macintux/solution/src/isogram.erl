-module(isogram).

-export([is_isogram/1, test_version/0]).

%% Sort and then compare each character of the string against the
%% previous. Any non-letter character can be used as the initial point
%% of comparison.
is_isogram(String) ->
    is_isogram(lists:sort(string:to_lower(String)), $.).

is_isogram([], _Prev) ->
    true;
is_isogram([H|_T], H) when H >= $a andalso H =< $z ->
    false;
is_isogram([H|T], _Prev) ->
    is_isogram(T, H).

test_version() ->
    1.
