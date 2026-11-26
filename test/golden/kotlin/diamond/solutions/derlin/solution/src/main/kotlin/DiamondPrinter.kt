class DiamondPrinter {

  fun printToList(letter: Char): List<String> {

    val rowLength = ((letter - 'A') * 2) + 1

    return (('A' until letter) + (letter downTo 'A')).map { current ->
      with(" ".repeat(rowLength).toMutableList()) {
        val index = letter - current
        this[index] = current
        this[rowLength - 1 - index] = current
        joinToString("")
      }
    }
  }
}
