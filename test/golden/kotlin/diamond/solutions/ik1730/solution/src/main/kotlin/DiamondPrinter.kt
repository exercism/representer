class DiamondPrinter {
    fun printToList(c: Char): List<String> {
        require(c in 'A'..'Z')
        val vp: List<Char> = ('A' until c) + (c downTo 'A')
        val hp: List<Char> = (c downTo 'A') + ('B'..c)
        return vp.map { y: Char -> hp.map { x -> if(x == y) y else ' '}.joinToString("")  }
    }
}