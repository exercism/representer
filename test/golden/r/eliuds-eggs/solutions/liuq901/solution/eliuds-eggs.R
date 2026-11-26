egg_count <- function(display_value) {
  if (display_value == 0)
    return(0)
  return(egg_count(display_value %/% 2) + display_value %% 2)
}
