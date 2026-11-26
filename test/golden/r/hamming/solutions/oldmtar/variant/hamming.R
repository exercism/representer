# This is a stub function to take two strings
# and calculate the hamming distance

hamming <- function(strand1, strand2) 
{
  
  if(nchar(strand1) != nchar(strand2)) stop('Input lengths must match')
  
  else 

  str.strand1 <- unlist(strsplit(strand1,""))
  str.strand2 <- unlist(strsplit(strand2,""))
  pos <- nchar(strand1)
  distance <- 0

  while(pos > 0)
  {
 
    if (str.strand1[pos] != str.strand2[pos])
      {distance <- distance + 1; pos <- pos + 1}
      
    else {pos <- pos - 1}
        
  }
  
  print(distance)
}

