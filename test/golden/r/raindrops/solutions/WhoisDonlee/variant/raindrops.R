raindrops <- function(number) {
  string <- ""
  if (number %% 3 == 0) string <- paste0(string, "Pling")
  if (number %% 5 == 0) string <- paste0(string, "Plang")
  if (number %% 7 == 0) string <- paste0(string, "Plong")
  if (string != "") string <- toString(number)
  string
}
