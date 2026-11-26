datatype planet = Mercury | Venus | Earth | Mars
                | Jupiter | Saturn | Neptune | Uranus

val seconds_in_year = 31557600.0;
val mercury_period = 0.2408467;
val venus_period = 0.61519726;
val mars_period = 1.8808158;
val jupiter_period = 11.862615;
val saturn_period = 29.447498;
val uranus_period = 84.016846;
val neptune_period = 164.79132;

fun earth_years seconds = Real.fromInt(seconds)/seconds_in_year

fun age_on planet seconds =
    case planet of
         Mercury => earth_years(seconds)/mercury_period
    |    Venus => earth_years(seconds)/venus_period
    |    Earth => earth_years(seconds)
    |    Mars => earth_years(seconds)/mars_period
    |    Jupiter => earth_years(seconds)/jupiter_period
    |    Saturn => earth_years(seconds)/saturn_period
    |    Uranus => earth_years(seconds)/uranus_period
    |    Neptune => earth_years(seconds)/neptune_period

