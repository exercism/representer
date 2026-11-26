hamming_distance(S1,S2,W) :-
        string_chars(S1, Ch1),
        string_chars(S2, Ch2),
        hd(Ch1,Ch2,W).

hd([],[],0).
hd([H|T1],[H|T2],W) :-
        !, hd(T1,T2,Wn),
        W is Wn.
hd([_|T1],[_|T2],W) :-
        !, hd(T1,T2,Wn),
        W is Wn + 1.
