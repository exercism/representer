colors <- c("black", "brown", "red", "orange", "yellow", "green", "blue", "violet", "grey", "white")

value <- function(resistor_colors) {
  band_1_value <- which(resistor_colors[1] == colors) - 1
  band_2_value <- which(resistor_colors[2] == colors) - 1
  final_value <-  band_1_value * 10 + band_2_value
}
