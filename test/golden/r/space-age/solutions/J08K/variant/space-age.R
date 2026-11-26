mercury <- 0.2408467
venus <- 0.61519726
mars <- 1.8808158
jupiter <- 11.862615
saturn <- 29.447498
uranus <- 84.016846
neptune <- 164.79132

earth_seconds <- 31557600 # Amount of seconds in an Earth year.

space_age <- function(seconds, planet) {
  earth_years = seconds / earth_seconds
  return (round(switch(
    planet,
    "mercury"= earth_years / mercury,
    "venus"= earth_years * venus,
    "earth"= earth_years,
    "mars"= earth_years / mars,
    "jupiter"= earth_years / jupiter,
    "saturn"= earth_years / saturn,
    "uranus"= earth_years / uranus,
    "neptune"= earth_years / neptune,   
  ), 2))
}
