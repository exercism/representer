hamming <- function(strand1,strand2) {
  strand1 <- strsplit(strand1, split = "")[[1]]
  strand2 <- strsplit(strand2, split = "")[[1]]
  
  if(length(strand1) == length(strand2))  {
    print(sum(strand1 != strand2))
  } else
    {
      stop();   
    }
}