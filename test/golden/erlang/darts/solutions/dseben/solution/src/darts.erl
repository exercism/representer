-module(darts).

-export([score/2]).


score(X, Y) ->
  score({X, Y}).

score(Point) ->
  Radius2Points = points(),
  SquaredRadius = maps:from_list([{R*R, R} || R <- maps:keys(Radius2Points)]),
  Within = first_smaller_equal(squared_distance(Point), maps:keys(SquaredRadius)),
  case Within of
    [] -> 0;
    _ -> maps:get(maps:get(Within, SquaredRadius), Radius2Points)
  end.

squared_distance({X, Y}) when is_number(X) and is_number(Y) ->
  X*X + Y*Y.

points() ->
  % key: radius of circle
  % value: points awarded
  #{
    1 => 10,
    5 => 5,
    10 => 1
  }.

first_smaller_equal(_Value, []) -> [];
first_smaller_equal(Value, [H | _T]) when H >= Value -> H;
first_smaller_equal(Value, [_ | T]) -> first_smaller_equal(Value, T).







