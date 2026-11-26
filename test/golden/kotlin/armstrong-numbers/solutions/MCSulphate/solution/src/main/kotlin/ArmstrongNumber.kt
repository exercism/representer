import kotlin.math.pow

object ArmstrongNumber {

    fun check(input: Int): Boolean =
        performArmstrongOperation(input) == input

    fun performArmstrongOperation(input: Int) =
        (0 until getNumDigits(input))
            .sumOf {
                getDigit(input, it).toDouble()
                    .pow(getNumDigits(input)).toInt()
            }

    fun getDigit(input: Int, index: Int): Int =
        ((input - (input % 10.0.pow(index))) / 10.0.pow(index)).toInt() % 10

    fun getNumDigits(input: Int): Int {
        var digits = 1
        while (10.0.pow(digits++) <= input);

        return digits - 1
    }

}
