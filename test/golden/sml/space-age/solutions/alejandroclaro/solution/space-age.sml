datatype planet = Mercury | Venus | Earth | Mars | Jupiter | Saturn | Uranus | Neptune

val second_in_earth_year = 31557600.0

fun planet_earth_year_ratio planet = 
  case planet of
      Mercury => 0.2408467
    | Venus => 0.61519726
    | Earth => 1.0
    | Mars => 1.8808158
    | Jupiter => 11.862615
    | Saturn => 29.447498
    | Uranus => 84.016846
    | Neptune => 164.79132

fun age_on planet seconds = 
  let
    val second_in_planet_year = second_in_earth_year * (planet_earth_year_ratio planet)
  in
    (Real.fromInt seconds) / second_in_planet_year
  end