-module(leap).

-export([leap_year/1]).

%leap_year(Year) when Year rem 400 =:= 0 -> true;
%leap_year(Year) when Year rem 100 =:= 0 -> false;
%leap_year(Year) when Year rem 4 =:= 0 -> true;
%leap_year(Year) when Year =:= Year -> false.


leap_year(Year) ->
    case Year of
        Year when Year rem 400 =:= 0 -> true;
        Year when Year rem 100 =:= 0 -> false;
        Year when Year rem 4 =:= 0 -> true;
        _ -> false
    end.

% on every year that is evenly divisible by 4
% except every year that is evenly divisible by 100
% unless the year is also evenly divisible by 400