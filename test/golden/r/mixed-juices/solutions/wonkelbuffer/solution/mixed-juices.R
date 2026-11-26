library(dplyr)

time_to_mix_juice <- function(juice) {
  case_when(
    juice == "Pure Strawberry Joy" ~ 0.5,
    juice %in% c("Energizer", "Green Garden") ~ 1.5,
    juice == "Tropical Island" ~ 3,
    juice == "All or Nothing" ~ 5,
    .default = 2.5
  )
}

wedges <- function(size) {
  case_when(
    size == "small" ~ 6,
    size == "medium" ~ 8,
    size == "large" ~ 10,
  )
}

limes_to_cut <- function(needed, limes) {
  
  recurse <- function(needed, limes, to_cut) {
    if (needed < 1 || !length(limes)) return(to_cut)
    recurse(needed - wedges(limes[1]), limes[-1], to_cut + 1)
  }
  
  recurse(needed, limes, 0)
}

order_times <- function(orders) {
  if (!length(orders)) return()
  print(time_to_mix_juice(orders[1]))
  order_times(orders[-1])
}

remaining_orders <- function(time_left, orders) {
  if(time_left <= 0) return(orders)
  time_for_next <- time_to_mix_juice(orders[1])
  remaining_orders(time_left - time_for_next, orders[-1])
}
