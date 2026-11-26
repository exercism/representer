
CLEAN_REGEXP <- "[[:punct:][:blank:]]"
CHECK_REGEXP <- "^1?([2-9]\\d{2}[2-9]\\d{6})$"

#' 
#' Clean up various formatting options for phone number from the 
#' North American Numbering Plan (NANP).
#' 
#'  @return cleaned phone number of NULL if the number is not valid
#'    for NANP.
#' 
parse_phone_number <- function(number_string) {
  cleaned <- gsub(CLEAN_REGEXP, "", number_string)
  match <- regexec(CHECK_REGEXP, cleaned)
      
  if (match[[1]][[1]] == -1) 
      return(NULL)
  else 
      # If CHECK_REGEXP matches the second capture is the 10-digit number
      # (The first capture is the whole expression)
      return(substring(cleaned, match[[1]][[2]]))
}
