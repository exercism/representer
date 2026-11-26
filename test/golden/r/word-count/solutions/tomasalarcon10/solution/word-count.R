word_count <- function(input) {
  # Replace all the quotes with spaces
  sentence <- gsub("^'|'$| '|' ", " ", input)

  # Replace all the special characters with spaces.
  sentence <- gsub("[\\.:;\"!&@%*$^,\n]", " ", sentence)
  # Reduce multiple spaces
  sentence <- trimws(tolower(gsub(" +", " ", sentence)))

  split_words_list <- strsplit(sentence, " ")

  # Get a list with all the frequency info
  table(split_words_list) %>% as.list()
}