class Matrix(private val matrixAsString: String) {

    fun column(colNr: Int): List<Int> {
        val rows = matrixAsString.split("\n")
        var mylist = mutableListOf<Int>()
        for(row in rows) {
            val rowC= row.split(Regex(" +"))
            mylist.add(rowC[colNr-1].toInt())
        }
        return mylist
    }

    fun row(rowNr: Int): List<Int> {
        val rows = matrixAsString.split("\n")
        val values = rows[rowNr-1].split(Regex(" +"))
        var mylist = mutableListOf<Int>()
        for(str in values) {
            mylist.add(str.toInt())
        }
        return mylist
    }
}
