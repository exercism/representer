class Squares(private val n: Int) {

    fun sumOfSquares(): Int {
        var sum = 0
        for (i in 1..n) {
            sum += i * i
        }
        return sum
    }

    fun squareOfSum(): Int {
        return Math.pow(((n * (n + 2)) / 2).toDouble(), 2.0).toInt()

    }

    fun difference(): Int {
        return squareOfSum() - sumOfSquares();
    }
}
