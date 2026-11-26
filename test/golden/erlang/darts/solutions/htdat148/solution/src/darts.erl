-module(darts).

-export([score/2]).


%% Coordinate {X, Y}
%% The distance from dart to target R*R = X*X + Y*Y
%% If R <= 1, earns 10 points
%% If 1 < R <= 5, earns 5 points
%% If 5 < R <= 10, earns 1 points
%% If R > 10, no points


score(X, Y) ->
    X1 = abs(X),
    Y1 = abs(Y),
    R  = math:sqrt(X1*X1 + Y1*Y1),
    Point = if 
		R =< 1 ->
		    10;
		R > 1 andalso R =< 5 ->
		    5;
		R > 5 andalso R =< 10  ->
		    1;
		true -> % outside the target
		    0
	    end,
    Point.
