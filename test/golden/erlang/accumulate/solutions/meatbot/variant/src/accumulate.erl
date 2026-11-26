-module(accumulate).

-export([accumulate/3]).

%%accumulate(_Fn, []) -> [];
%%accumulate(Fn, [H | T]) -> [Fn(H) | accumulate(Fn, T)].

accumulate(Fn, Ls) -> accumulate(Fn, Ls, []).

accumulate(_Fn, [], Res) -> lists:reverse(Res);
accumulate(Fn, [H | Ls], Res) -> accumulate(Fn, Ls, [Fn(H) | Res]).