:- use_module(library(clpfd)).

say(N, English) :- once(phrase(say(N), Codes)), string_codes(English, Codes).

say(0)  --> "zero".
say(1)  --> "one".
say(2)  --> "two".
say(3)  --> "three".
say(4)  --> "four".
say(5)  --> "five".
say(6)  --> "six".
say(7)  --> "seven".
say(8)  --> "eight".
say(9)  --> "nine".
say(10) --> "ten".
say(11) --> "eleven".
say(12) --> "twelve".
say(13) --> "thirteen".
say(14) --> "fourteen".
say(15) --> "fifteen".
say(16) --> "sixteen".
say(17) --> "seventeen".
say(18) --> "eighteen".
say(19) --> "nineteen".
say(20) --> "twenty".
say(30) --> "thirty".
say(40) --> "forty".
say(50) --> "fifty".
say(60) --> "sixty".
say(70) --> "seventy".
say(80) --> "eighty".
say(90) --> "ninety".

say(N) -->
    { N in 1_000_000_000..999_999_999_999, divmod(N, 1_000_000_000, Q, R) },
    say(Q), " billion",
    ( { R #= 0 } -> [] ; " ", say(R) );
    { N in 1_000_000..999_999_999, divmod(N, 1_000_000, Q, R) },
    say(Q), " million",
    ( { R #= 0 } -> [] ; " ", say(R) );
    { N in 1_000..999_999, divmod(N, 1_000, Q, R) },
    say(Q), " thousand",
    ( { R #= 0 } -> [] ; " ", say(R) );
    { N in 100..999, divmod(N, 100, Q, R) },
    say(Q), " hundred",
    ( { R #= 0 } -> [] ; " ", say(R) );
    { N in 21..99, divmod(N, 10, Q0, R), R #\= 0, Q #= 10 * Q0 },
    say(Q), "-", say(R).
