leap <- function(year)
  { c <-( year %% 4 == 0 & (year %% 100 != 0 || year %% 400 !=0))
  return(c)
  }
leap(1900)