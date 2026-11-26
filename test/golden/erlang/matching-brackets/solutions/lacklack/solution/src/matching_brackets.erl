-module(matching_brackets).

-export([is_paired/1]).


is_paired(String) -> is_paired(String, []).

is_paired([], []) -> true;
is_paired([], _)  -> false;

is_paired([${|T], Acc) -> is_paired(T, [${|Acc]);
is_paired([$(|T], Acc) -> is_paired(T, [$(|Acc]);
is_paired([$[|T], Acc) -> is_paired(T, [$[|Acc]);

is_paired([$}|T], [${|R]) -> is_paired(T, R);
is_paired([$)|T], [$(|R]) -> is_paired(T, R);
is_paired([$]|T], [$[|R]) -> is_paired(T, R);

is_paired([$}|_], _) -> false;
is_paired([$)|_], _) -> false;
is_paired([$]|_], _) -> false;

is_paired([_|T], Acc) -> is_paired(T, Acc).

