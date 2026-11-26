parse_phone_number <- function(number_string) {
  out <- sub('^1', '', gsub('\\D', '', number_string))
  ifelse(grepl('^[2-9]{1}[0-9]{2}[2-9]{1}[0-9]{6}$', out),
         return(out) , return(NULL))
}