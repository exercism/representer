score <- function(x,y) {
  x=abs(x)
  y=abs(y)
  if(abs(sum(x,y))<=1.4) {
     10
  }
  else if(abs(sum(x,y))>7 && abs(sum(x,y))<=14)  {
    1
  }
  else if(abs(sum(x,y))>1.5 && abs(sum(x,y))<=7)  {
    5
  }
  else if(abs(sum(x,y))>14)  {
    0
  }
  else print("bla")
}
score(0, 10)
