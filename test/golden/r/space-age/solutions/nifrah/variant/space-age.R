space_age <- function(seconds, planet) {
  # Earth seconds in a year
  earth_year_in_seconds <- 31557600
  
  # Orbital periods for each planet (in Earth years)
  orbital_periods <- list(
    "mercury" = 0.2408467,
    "venus" = 0.61519726,
    "earth" = 1.0,
    "mars" = 1.8808158,
    "jupiter" = 11.862615,
    "saturn" = 29.447498,
    "uranus" = 84.016846,
    "neptune" = 164.79132
  )
  
  # Convert planet name to lowercase for case-insensitive matching
  planet_lower <- tolower(planet)
  
  # Check if the planet is valid
  if (!planet_lower %in% names(orbital_periods)) {
    stop(paste("Invalid planet:", planet))
  }
  
  # Calculate age on the specified planet
  # First convert seconds to Earth years, then adjust for the planet's orbital period
  earth_years <- seconds * earth_year_in_seconds
  planet_years <- earth_years / orbital_periods[[planet_lower]]
  
  # Round to 2 decimal places
  return(round(planet_years, 2))
}
