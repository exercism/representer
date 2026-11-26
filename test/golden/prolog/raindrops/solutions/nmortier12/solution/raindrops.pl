convert(N, Sounds):-
    (0 is N mod 3, 0 is N mod 5, 0 is N mod 7) -> Sounds = "PlingPlangPlong";
    (0 is N mod 3, 0 is N mod 5) -> Sounds = "PlingPlang";
    (0 is N mod 3, 0 is N mod 7) -> Sounds = "PlingPlong";
    (0 is N mod 5, 0 is N mod 7) -> Sounds = "PlangPlong";
    (0 is N mod 3) -> Sounds = "Pling" ;
    (0 is N mod 5) -> Sounds = "Plang" ;
    (0 is N mod 7) -> Sounds = "Plong" ;
    number_string(N,Sounds).