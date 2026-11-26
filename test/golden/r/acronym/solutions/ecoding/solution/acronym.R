acronym <- function(input) {
    input_acronym <- ""
    input <- strsplit(toupper(input), "\\ |\\.|\\,|\\-|\\_")[[1]]
    for (word in input) {
        input_acronym <- paste(input_acronym, substr(word, 1, 1), sep = "")
    }
    input_acronym
}
