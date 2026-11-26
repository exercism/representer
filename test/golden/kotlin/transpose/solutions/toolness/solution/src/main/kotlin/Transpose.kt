object Transpose {

    fun transpose(input: List<String>): List<String> {
        val outputRows = mutableListOf<String>()

        for (row in input.withIndex()) {
            for (col in row.value.withIndex()) {
                if (outputRows.size < col.index + 1) {
                    outputRows.add("")
                }
                var outputRow = outputRows[col.index]
                for (i in outputRow.length..row.index - 1) {
                    outputRow = outputRow + ' '
                }
                outputRows[col.index] = outputRow + col.value
            }
        }

        return outputRows
    }
}
