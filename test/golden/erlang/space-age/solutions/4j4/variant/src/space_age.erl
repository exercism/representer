-module(space_age).

-export([age/2]).


age(earth, _Seconds) -> calc(_Seconds,1.0);
age(mercury, _Seconds) -> calc(_Seconds,0.2408467);
age(venus, _Seconds) -> calc(_Seconds,0.61519726);
age(mars, _Seconds) -> calc(_Seconds,1.8808158);
age(jupiter, _Seconds) -> calc(_Seconds,11.862615);
age(saturn, _Seconds) -> calc(_Seconds,29.447498);
age(uranus, _Seconds) -> calc(_Seconds,84.016846);
age(neptune, _Seconds) -> calc(_Seconds,164.79132).

calc(Sec,Fac) ->
    Sec / 31557600 * Fac.
