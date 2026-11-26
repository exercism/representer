% on every year that is evenly divisible by 4
%   except every year that is evenly divisible by 100
%     unless the year is also evenly divisible by 400

leap(Y) :-
    0 is Y mod 4,
    0 =\= Y mod 100; 
    0 is Y mod 400.