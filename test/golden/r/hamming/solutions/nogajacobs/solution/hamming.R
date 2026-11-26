hamming <- function(strand1, strand2) {
  if((nchar(strand1) != nchar(strand2)))
    {stop()}
    count <- 0
  if(strand1 == "")
    {return(0)}
    str1 <- strsplit(strand1, "")[[1]]
    str2 <- strsplit(strand2, "")[[1]]
    for(i in 1:length(str1)){
      if(str1[i] != str2[i])
        {count <- count + 1}
      }
    return(count)
  }