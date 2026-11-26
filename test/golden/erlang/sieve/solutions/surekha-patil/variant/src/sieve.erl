-module(sieve).

-export([primes/1]).


primes(_Limit) -> get_prime(2,_Limit,[]).




get_prime(_Start,_End,Res) when _Start =< _End->
           % io:format("_start=~p~n",[_Start]),
    case prime_number(_Start,2) of
        true->get_prime(_Start+1,_End,[_Start|Res]);
        false->get_prime(_Start-1,_End,Res) end;

get_prime(_Start,_End,_Res)  ->lists:reverse(_Res).


prime_number(_Start,_Num) when _Start rem _Num =:=0 andalso _Num =:= _Start->
   % io:format("_num=~p~n",[_Num]),
    true;

prime_number(_Start,_Num) when _Start rem _Num =/=0 andalso _Num < _Start ->
    %io:format("_num=~p~n",[_Num]),
    prime_number(_Start,_Num+1);

prime_number(_Start,_Num) ->
    false.