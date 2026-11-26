library(stringr)

message <- function(msg) {
  strsplit(msg, ": ")[[1]][2] |> trimws()
}

log_level <- function(msg) {
  strsplit(msg, ": ")[[1]][1] |>
    str_remove_all("\\[|\\]") |> 
    str_to_lower()
}

reformat <- function(msg) {
  sprintf("%s (%s)", message(msg), log_level(msg)) 
}
