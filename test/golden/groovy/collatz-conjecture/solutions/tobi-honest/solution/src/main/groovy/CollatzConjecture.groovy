class CollatzConjecture {

    static int steps(int number) {
        if(number<1){
            throw new ArithmeticException()
        }
        return steps1(number, 0)
    }

    static int steps1(int number, int steps){
        if(number == 1){
            return steps
        } else{
            if(number % 2 == 0){
                steps1((number/2) as Integer, steps+1)
            } else{
                steps1((number*3+1) as Integer, steps+1)
            }
        }
    }
}