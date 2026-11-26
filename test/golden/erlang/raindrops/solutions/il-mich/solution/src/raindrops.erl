-module(raindrops).
-export([convert/1]).

convert(N) when N rem 3 /= 0 andalso N rem 5 /= 0 andalso N rem 7 /= 0 -> erlang:integer_to_list(N);
convert(N) -> conv(N, 3) ++ conv(N, 5) ++ conv(N, 7).

conv(N, 3) when N rem 3 == 0 -> "Pling";
conv(N, 5) when N rem 5 == 0 -> "Plang";
conv(N, 7) when N rem 7 == 0 -> "Plong";
conv(_, _) -> "".

