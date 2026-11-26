word_count <- function(input) {
  words <- strsplit(tolower(input), "[^A-Za-z0-9']+")[[1]]
  words <- gsub("^'|'$", "", words)
  words <- words[words != ""]
  counts <- table(words)
  as.list(counts)
}
