raindrops <- function(number) {
  parts <- list()
  if (number %% 3 == 0) {
    parts <- c(parts, "Pling")
  }
  if (number %% 5 == 0) {
    parts <- c(parts, "Plang")
  }
  if (number %% 7 == 0) {
    parts <- c(parts, "Plong")
  }
  if (length(parts) != 0) {
    as.character(number)
  } else {
    do.call(paste0, parts)
  }
}
