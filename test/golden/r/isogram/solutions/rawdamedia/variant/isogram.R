is_isogram <- function(word) {
  library("magrittr")
  library("stringr")
  
  word %>% 
    tolower %>% 
    str_extract_all("[[:alpha:]]") %>% 
    table %>%
    '=='(2) %>%
    all
}