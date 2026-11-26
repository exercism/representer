-module(rational_numbers).

%TIL: Spec -type rational() :: {integer(), integer()}.

-export([absolute/1, add/2, divide/2, exp/2, mul/2, reduce/1, sub/2]).


absolute({A, B}) -> reduce({abs(A), abs(B)}).

add({A1, B1}, {A2, B2}) -> reduce({(A1 * B2) + (A2 * B1), (B1 * B2)}).

divide({A1, B1}, {A2, B2}) when A2 =/= 0; B1 =/= 0 -> reduce({A1 * B2, B1 * A2}).

exp({A, B}, E) when is_integer(E), E >= 0 -> convert({math:pow(A, E), math:pow(B, E)});
exp({A, B}, E) when is_integer(E) -> convert({math:pow(B, abs(E)), math:pow(A, abs(E))});
exp({A, B}, E) when is_float(E) -> convert({math:pow(A, E), math:pow(B, E)});
% real ^ rational; x-root -> pow(n, 1/x)
exp(R, {A, B}) -> math:pow(math:pow(R, A), 1 / B).

convert({A, B}) when is_float(A); is_float(B) -> reduce({trunc(A), trunc(B)}).

mul({A1, B1}, {A2, B2}) -> reduce({A1 * A2, B1 * B2}).

reduce({0, _}) -> {0, 1};
reduce({_, 0}) -> erlang:error(badarg); % not a rational number
% TIL: Sign could be computed with checking only B < 0 and multiply both A & B by Sign
% TIL: To change sign, prefix "-" is adequate
reduce({A, B}) -> 
    Sign = if
        B < 0 -> -1;
        true -> 1
    end,
    G = gcd(A, B),
    {(A div G) * Sign, (B div G) * Sign}.

sub({A1, B1}, {A2, B2}) -> reduce({(A1 * B2) - (A2 * B1), (B1 * B2)}).


% TIL: I refreshed that gcd can be computed using recursive modulo
%   gcd(A, B) -> gcd(B, A rem B) until (0, 0) -> 1, (A, 0) -> A
% This solution doesn't require converting numbers to absolute values
gcd(A, B) -> gcd(abs(A), abs(B), 2, 1).

gcd(A, B, F, Acc) when F > A; F > B -> Acc;
gcd(A, B, F, Acc) when A rem F =:= 0, B rem F =:= 0 ->
    gcd(A div F, B div F, F, Acc*F);
gcd(A, B, F, Acc) ->
    gcd(A, B, F+1, Acc).
