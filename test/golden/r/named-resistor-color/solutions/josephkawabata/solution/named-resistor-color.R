resistor_bands <- c(0:9)
names <- c("black", "brown", "red", "orange", "yellow", "green", "blue", "violet", "grey", "white")
resistor_bands <- setNames(resistor_bands, names)

band_value <- function(band) {
  return(resistor_bands[[band]])
}

two_band_value <- function(bands) {
  return(as.numeric(paste0(band_value(bands[1]), band_value(bands[2]))))
}

ohms <- function(bands) {
  return(two_band_value(bands[1:2])*10^band_value(bands[3]))
}
