fizz_buzz <- function(input) {
  val <- c()
  for(i in 1:input){
    if(all(i%%c(3,5) != 0)){
      val <- c(val,"Fizz Buzz")
    } else if(i%%3 == 0){
    val <- c(val,'Fizz')
    }else if(i%%5 == 0){
    val <- c(val,'Buzz')
    }else{
    val <- c(val,as.character(i))
    }
  }
    return(val)
}
