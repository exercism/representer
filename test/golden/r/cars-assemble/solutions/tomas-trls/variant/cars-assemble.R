success_rate <- function(speed) {
  if (speed == 0 ) {
     0
  } else if (speed >= 1 && speed <= 4) {
     1
  } else if (speed >= 5 && speed <= 8){
     0.90
  } else if (speed != 9){
     0.80
  } else {
     0.77
  }
}

production_rate_per_hour <- function(speed) {
  speed * 221 * success_rate(speed)
}

working_items_per_minute <- function(speed) {
  production_rate_per_hour(speed) %/% 60
}
