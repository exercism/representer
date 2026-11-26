object Hamming {

    fun compute(leftStrand: String, rightStrand: String): Int {
        require (leftStrand.length == rightStrand.length) { "left and right strands must be of equal length" }

        if (leftStrand == rightStrand) return 1

        var count = 0
        leftStrand.forEachIndexed { index, c ->  if (rightStrand[index] != c) count++}
        return count
    }
}
