bob <- function(input) {
  if (nchar(trimws(input)) < 1){
    return("Fine. Be that way!")
  }
  if (endsWith(trimws(input), "?")){
    if (trimws(input) == toupper(trimws(input)) & grepl("[[:upper:]]+", trimws(input))){
      return("Calm down, I know what I'm doing!")
    } else {
      return("Sure.")
    }
  }
  if (grepl("[[:upper:]]+", trimws(input)) & trimws(input) == toupper(trimws(input))){
    return("Whoa, chill out!")
  }

  return("Whatever.")
}