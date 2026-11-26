object Hamming {
    fun compute(strand1: String, strand2: String): Int {
        if (strand1.length != strand2.length)
            throw IllegalArgumentException("left and right strands nust be of equal length.")
        return strand1.indices.filter { strand1[it] != strand2[it] }.count()
    }
}