is_armstrong_number <- function(n) {
  arm_list <- as.array(strsplit(as.character(n), "")[[1]])

  arm_number <- 0
  list_len = length(arm_list)

  if(list_len == 2) {
    return(FALSE)
  }

  for (x in arm_list) {
    arm_number <- arm_number + as.numeric(x)^list_len
  }

  if(arm_number == n) {
    return(TRUE)
  }
  else {
    return(FALSE)
  }
}