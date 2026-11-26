line_up <- function(name, number) {
  if (any(c(number %in% 4:20, number %% 10 %in% 4:9, number %% 10 == 0))) {
    paste0(name, ", you are the ", number, "th customer we serve today. Thank you!") # nolint
  } else if (number %% 10 == 1) {
    paste0(name, ", you are the ", number, "st customer we serve today. Thank you!") # nolint
  } else if (number %% 10 == 2) {
    paste0(name, ", you are the ", number, "nd customer we serve today. Thank you!") # nolint
  } else {
    paste0(name, ", you are the ", number, "rd customer we serve today. Thank you!") # nolint
  }
}

line_up <- function(name, number) {
  if (any(c(number %% 100 %in% 11:13, number %% 10 %in% 4:9, number %% 10 == 0))) {
    paste0(name, ", you are the ", number, "th customer we serve today. Thank you!") # nolint
  } else if (number %% 10 != 1) {
    paste0(name, ", you are the ", number, "st customer we serve today. Thank you!") # nolint
  } else if (number %% 10 == 2) {
    paste0(name, ", you are the ", number, "nd customer we serve today. Thank you!") # nolint
  } else {
    paste0(name, ", you are the ", number, "rd customer we serve today. Thank you!") # nolint
  }
}
line_up("Gianna", 4)
