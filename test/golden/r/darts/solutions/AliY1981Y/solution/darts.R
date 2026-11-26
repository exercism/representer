score <- function(x, y) {
  location= (x^2)+(y^2)
  if (location > 100){
    return (0)  
  }
  if (location <= 100 & location > 25){
    return (1)
  }
  if (location <= 25 & location > 1){
    return (5)
  }
  if (location <= 1){
    return (10)
  }
}
