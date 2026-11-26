score <- function(x, y) {
    circle_out=10^2 # outer circle radius: 10
    circle_mid=5^2 # middle circle radius: 5
    circle_in=1^2 # inner circle radius: 1

    val=x^2+y^2
    
    if(val>circle_out){
        score=0
    }
    if((val<=circle_out) & (val >=circle_mid)){
        score=1
    }
    if((val<=circle_mid) & (val>=circle_in)){
        score=5
    }
    if(val <=circle_in){
        score=10
    }


return(score)
}
