datatype planet = Mercury | Venus | Earth | Mars
                | Jupiter | Saturn | Neptune | Uranus

val secondsPerEarthYear: real = 31557600.0

fun earthYearsPerPlanetYears (planet: planet): real = case planet of
    Mercury => 0.2408467
  | Venus => 0.61519726
  | Earth => 1.0
  | Mars => 1.8808158
  | Jupiter => 11.862615
  | Saturn => 29.447498
  | Uranus => 84.016846
  | Neptune => 164.79132

fun age_on (planet: planet) (seconds: int): real =
  Real.fromInt seconds / secondsPerEarthYear / earthYearsPerPlanetYears planet
