import kotlin.math.pow

object ArmstrongNumber {
    fun check(input: Int): Boolean {
        if (input < 11) return true

        val digits = input.toString().map { it.digitToInt().toDouble() }
        return digits.sumOf { it.pow(digits.size) } == input.toDouble()
    }
}
