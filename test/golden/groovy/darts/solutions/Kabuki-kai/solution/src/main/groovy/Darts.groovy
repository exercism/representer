class Darts {

    static int score(x, y) {
        
    def sqrtxy = Math.sqrt(x*x + y*y)

    if (sqrtxy <=1) {return 10}
    else if (sqrtxy <= 5) {return 5}
    else if (sqrtxy <= 10) {return 1}
    else {return 0}
        
    }
}