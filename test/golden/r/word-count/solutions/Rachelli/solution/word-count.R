library(stringr)
word_count <- function(input) {
  input %>%
    str_to_lower() %>%
    str_extract_all(boundary("word")) %>%
    table() %>%
    as.list()
}