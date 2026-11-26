-module(zipper).
-export([new_tree/3, from_tree/1, to_tree/1, up/1, left/1, right/1, value/1, set_value/2, set_left/2, set_right/2]).
new_tree(Value, Left, Right) ->
  {Value, Left, Right}.
to_tree({[], Value, Left, Right}) ->
  {Value, Left, Right};
to_tree(Zipper) ->
  to_tree(up(Zipper)).
from_tree({Value, Left, Right}) ->
  {[], Value, Left, Right}.
value({_, Value, _, _}) -> 
  Value.
set_value({Path, _, Left, Right}, Value) -> 
  {Path, Value, Left, Right}.
set_left({Path, Value, _, Right}, Left) -> 
  {Path, Value, Left, Right}.
set_right({Path, Value, Left, _}, Right) -> 
  {Path, Value, Left, Right}.
left({_, _, nil, _}) -> nil;
left({Path, CurrentValue, {NextValue, NextLeft, NextRight}, CurrentRight}) ->
  NextPath = [{left, CurrentValue, CurrentRight}|Path],
  {NextPath, NextValue, NextLeft, NextRight}.
right({_, _, _, nil}) -> nil;  
right({Path, CurrentValue, CurrentLeft, {NextValue, NextLeft, NextRight}}) ->
  NextPath = [{right, CurrentValue, CurrentLeft}|Path],
  {NextPath, NextValue, NextLeft, NextRight}.
up({[], _, _, _}) -> nil;
up({[{left, Value, Right}|T], CurrentValue, CurrentLeft, CurrentRight}) ->
  Left = {CurrentValue, CurrentLeft, CurrentRight},
  {T, Value, Left, Right};
up({[{right, Value, Left}|T], CurrentValue, CurrentLeft, CurrentRight}) ->
  Right = {CurrentValue, CurrentLeft, CurrentRight},
  {T, Value, Left, Right}.