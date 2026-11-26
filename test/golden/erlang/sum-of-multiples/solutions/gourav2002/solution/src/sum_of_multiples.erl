-module(sum_of_multiples).

-export([sum/2]).

sum(Factors, Limit) -> 

    lists:sum(lists:usort(
        [X*F || 
            F <- Factors, F /= 0, 
            X <- lists:seq(1,Limit div F), 
            X*F < Limit])).