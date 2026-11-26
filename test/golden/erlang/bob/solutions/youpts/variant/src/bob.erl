-module(bob).

-export([response/1]).

response(String) ->
	TrimString = string:trim(String, trailing),
	case TrimString of
		[] -> "Fine. Be that way!";
		_ -> response(is_question(TrimString), is_yelling(TrimString))
	end.

response(true, true) -> "Calm down, I know what I'm doing!";
response(true, _) -> "Sure.";
response(_, true) -> "Whoa, chill out!";
response(_, _) -> "Whatever.".

is_question(S) -> lists:last(S) =:= $?.
is_yelling(S) ->
    string:uppercase(S) =:= S andalso
        not(string:lowercase(S) =/= S).