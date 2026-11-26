import kotlin.math.roundToInt
import kotlin.math.sqrt

object CryptoSquare {

    fun ciphertext(plaintext: String): String {
        if (plaintext == "")
            return ""
        
        return cipher(plaintext)
    }

    fun cipher(plaintext: String): String {
        val sentence = plaintext
            .split(" ", "-")
            .joinToString("")
            .lowercase()
            .replace("[^a-z0-9 ]".toRegex(), "")
        val count = sentence.length
        val division = findDivision(count)
    
        var encrypted = ""
    
        for (i in 0..division.rows - 1) {
           for (j in 0..division.columns - 1) {
               val pointer = i + (j * division.rows)
    
               if (pointer <= (sentence.length -1))
                   encrypted += sentence[pointer]
               else
                   encrypted += " "               
           }
        }
    
        return encrypted.chunked(division.columns).joinToString(" ")
    }
    
    fun findDivision(length: Int): DivisionSolution{
        var length = length.toDouble()
    
        for (i in 1..sqrt(length).roundToInt() + 1) {
            if (i * (i - 1) >= length) {
                return DivisionSolution(i - 1, i)
            }
            if (i * i >= length) {
                return DivisionSolution(i, i)
            }
        }
        throw IllegalStateException("Unable to find division")
    }
    
    class DivisionSolution(
        val columns: Int,
        val rows: Int
        )
}