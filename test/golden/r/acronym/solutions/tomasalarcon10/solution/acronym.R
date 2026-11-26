# Prepend a space to the upper case version of the input.
# Now we are looking for a letter that is preceded by a non-letter.

acronym <- function(input) {
    chars <- strsplit(paste0(" ", toupper(input)), "")[[1]]
    test  <- chars %in% LETTERS
    test  <- test | (chars == "'" & c(FALSE, test[-length(test)]))
    where <- test & !c(FALSE, test[-length(test)])
    paste(chars[where], sep="", collapse="")
}