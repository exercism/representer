-module(beer_song).

-export([verse/1, sing/1, sing/2]).

verse(0) ->
  io_lib:format("No more bottles of beer on the wall, no more bottles of beer.~n"
  "Go to the store and buy some more, 99 bottles of beer on the wall.~n", []);

verse(1) ->
  io_lib:format("1 bottle of beer on the wall, 1 bottle of beer.~n"
  "Take it down and pass it around, no more bottles of beer on the wall.~n", []);

verse(2) ->
  io_lib:format("2 bottles of beer on the wall, 2 bottles of beer.~n"
  "Take one down and pass it around, 1 bottle of beer on the wall.~n", []);

verse(N) ->     
  io_lib:format("~p bottles of beer on the wall, ~p bottles of beer.~n"
  "Take one down and pass it around, ~p bottles of beer on the wall.\n",[N, N, N-1] ).

sing(N) ->
  sing(N, 0).
sing(From, To) ->
  string:concat(lists:join("\n", lists:map(fun(N) -> verse(N) end, lists:reverse(lists:seq(To, From)))), "\n").
