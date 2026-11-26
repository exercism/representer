score <- function(x, y) {
  d <- sqrt((x^2)+(y^2));
  if(d <= 1){
    10
  }
  else if(d <= 5){
    5
  }
  else if(d <= 10){
    1
  }
  else{
    0
  }
}
