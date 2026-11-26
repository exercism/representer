collatz_step_counter <- function(nums) {
  if (any(nums <= 0)) {
    stop("Error: Input cannot be zero.")
  }

  steps <- numeric(length(nums))
  memo <- vector("list", length(nums))

  for (i in seq_along(nums)) {
    num <- nums[i]
    current_steps <- 0

    while (num > 1) {
      if (num %% 2 == 0) {
        num <- num / 2
      } else {
        num <- 3 * num + 1
      }
      current_steps <- current_steps + 1

      if (num %in% names(memo[[i]])) {
        current_steps <- current_steps + memo[[i]][[as.character(num)]]
        break
      }
    }

    memo[[i]][[as.character(num)]] <- current_steps
    steps[i] <- current_steps
  }

  return(steps)
}

