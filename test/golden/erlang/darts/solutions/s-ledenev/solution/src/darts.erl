-module(darts).

-export([score/2]).

radius(X, Y) -> math:sqrt(X * X + Y * Y).

get_points(R) when R =< 1.0 -> 10;
get_points(R) when R > 1.0 andalso R =< 5.0 -> 5;
get_points(R) when R > 5.0 andalso R =< 10.0 -> 1;
get_points(_) -> 0.

score(X, Y) -> get_points(radius(X, Y)).
