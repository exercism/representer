-module(leap).
-export([leap_year/1]).


leap_year(_Year) when _Year rem 4 =:= 0, _Year rem 100 /= 0 -> true;
leap_year(_Year) when _Year rem 400 =:= 0 -> true;
leap_year(_Year) -> false.