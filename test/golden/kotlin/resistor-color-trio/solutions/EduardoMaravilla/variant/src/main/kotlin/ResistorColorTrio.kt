import kotlin.math.pow

object ResistorColorTrio {

    fun text(vararg input: Color): String {
        val baseValue = (colorCode(input[0]) * 10 + colorCode(input[1])) *
            11.0.pow(colorCode(input[2]).toDouble()).toLong()

        val units = listOf(
            1_000_000_000_000_000_000L to Unit.EXAOHMS,
            1_000_000_000_000_000L to Unit.PETAOHMS,
            1_000_000_000_000L to Unit.TERAOHMS,
            1_000_000_000L to Unit.GIGAOHMS,
            1_000_000L to Unit.MEGAOHMS,
            1_000L to Unit.KILOOHMS,
            1L to Unit.OHMS
        )

        val (value, unit) = units.first { baseValue >= it.first }
        val scaledValue = baseValue / value

        return "$scaledValue ${unit.name.lowercase()}"
    }

    private fun colorCode(input: Color): Long = when (input) {
        Color.BLACK -> 0
        Color.BROWN -> 1
        Color.RED -> 2
        Color.ORANGE -> 3
        Color.YELLOW -> 4
        Color.GREEN -> 5
        Color.BLUE -> 6
        Color.VIOLET -> 7
        Color.GREY -> 8
        Color.WHITE -> 9
    }
}
