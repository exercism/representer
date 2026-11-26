largest_series_product <- function(digits, span) {

  if (span < 0 || span > nchar(digits)) {
    stop("Span is less than 0 or greatre than the digit length")
  }

  seq_start <- seq(1, nchar(digits) - span + 1, 1)
  seq_end <- seq(span, nchar(digits), 1)
  max_product <- 0
  for (series in substring(digits, seq_start, seq_end)) {
    numbers <- suppressWarnings(as.integer(unlist(strsplit(series, ""))))
    if (any(is.na(numbers))) {
      stop("Non number in the digits")
    }
    product <- prod(numbers)
    if (product > max_product) {
      max_product <- product
    }
  }
  max_product
}