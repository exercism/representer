scrabble_score <- function(input){
  if(nchar(input) == 0) return(0)
  letterss = c("A", "E", "I", "O", "U", "L", "N", "R", "S", "T", "D", "G", "B", "C", "M", "P", "F", "H", "V", "W", "Y", "K", "J", "X", "Q", "Z")
  values <- c(rep(1, 10), rep(2,2), rep(3,4), rep(4,5), 5, rep(8,2), rep(10,2))
  def_cor <- data.frame(letterss, values)
  
  
  split_input <- toupper(strsplit(input, "")[[1]])
  sum(sapply(toupper(strsplit(input, "")[[1]]), function(x){ifelse(any(def_cor$letterss == x), def_cor$values[which(def_cor$letterss == x)], 0)}))
}