-module(pangram).

-export([is_pangram/1]).


is_pangram(Sentence) -> 
    All="abcdefghijklmnopqrstuvwxyz",
    Chars=ordsets:from_list(string:lowercase(Sentence)),
    ordsets:is_subset(All,Chars).
