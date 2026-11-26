import kotlin.math.max
import kotlin.math.min

class DiamondPrinter {
    fun printToList(c: Char): List<String> {
        val chars = ('A'..c).toList() // Generate list of characters
        val range = listOf(0..chars.size-1, (chars.size - 2) downTo 0).flatten() // Generate list of indices

        return (range).map { // For each index (Char), generate a line
            val s = "".padStart((chars.size * 2) - 1, ' ').toCharArray() // Create empty string with whitespace of appropriate size

            val mid: Int = (range.size / 2) + (range.size % 2) - 1 // Calculate middle index
            val offset = it // Use index as offset from center

            // We ignore the case of only one character, it will assign the value twice but who cares
            s[mid + offset] = chars[it] // Assign right character to middle + offset
            s[mid - offset] = chars[it] // Assign left character to middle - offset

            return@map s.joinToString("")
        }
    }


}
