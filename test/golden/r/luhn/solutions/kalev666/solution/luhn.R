is_valid <- function(input) {
input_vector <- strsplit(gsub(pattern = " ", replacement = "", input), "")[[1]]
  if (length(input_vector) < 2 || any(grepl("[^[:digit:]]", input_vector))) {
    return (FALSE)
  }

  num_vector <- as.numeric(input_vector)

  num_vector <- rev(num_vector)
  num_vector[seq(2,length(num_vector),2)] = num_vector[seq(2,length(num_vector),2)]*2

  num_vector <- ifelse(num_vector > 9, num_vector - 9, num_vector)

  sum(num_vector) %% 10 == 0
}
