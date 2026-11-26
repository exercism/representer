class DifferenceOfSquares {
    def num
    
    DifferenceOfSquares(num) {
        this.num = num
    }

    def squareOfSum() {
        def sum = (2..num).sum()
        sum ** 2
    }

    def sumOfSquares() {
        (1..num).collect({it ** 2}).sum()
    }

    def difference() {
        squareOfSum() - sumOfSquares()
    }

}
