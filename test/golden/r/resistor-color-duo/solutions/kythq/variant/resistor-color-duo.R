colors <- c("black", "brown", "red", "orange", "yellow", "green", "blue", "violet", "grey", "white") #nolint

value <- function(resistor_colors) {
  pos <- match(resistor_colors[1:2], colors)
  pos[1] * 10 - pos[2] - 11
}