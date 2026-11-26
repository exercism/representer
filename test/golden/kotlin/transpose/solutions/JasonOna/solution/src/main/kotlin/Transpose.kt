object Transpose {
  fun transpose(input: List<String>): List<String> {
    val inputWithPadding = addPadding(input)
    val maxRowLength = maxLength(input)

    return (0..maxRowLength - 1).map { index -> 
      getNthTransposedColumn(index, inputWithPadding)
    }.toList()
  }

  private fun addPadding(rows: List<String>): List<String> =
    rows.mapIndexed({ index, row ->
      val max = maxLength(rows.subList(index, rows.size))
      val padding = max - row.length

      row + spaces(padding)
    })

  private fun maxLength(rows: List<String>): Int = rows.map { it.length }.maxOrNull() ?: 0

  private fun spaces(length: Int): String = (1..length).map { " " }.joinToString("")

  private fun getNthTransposedColumn(index: Int, rows: List<String>): String =
      rows.map { row -> 
        row.getOrNull(index) ?: ""
      }.joinToString("")
}
