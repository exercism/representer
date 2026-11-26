object Transpose {

    fun transpose(input: List<String>): List<String> {
        if(input.isEmpty()) return input
        val colSize = input.maxBy { it.length }?.length?:0
        val rowSize = input.size
        val listStr = MutableList(colSize) {""}
        var prevLength : Int = 0
        for(it in input) {
            var item = it+" ".repeat(colSize-it.length)
            for(ind in 0 until item.length) {
                listStr[ind]+="${item[ind]}"
            }
        }
        for((index, item) in listStr.asReversed().withIndex()) {
            var trimItem = item.trimEnd()
            var trimLength = trimItem.length
            if(trimLength<rowSize) {
                if (trimLength >= prevLength) {
                    listStr[colSize - 1 - index] = trimItem
                    prevLength = trimLength
                } else {
                    listStr[colSize - 1 - index] = item.dropLast(rowSize-prevLength)
                }
            } else {
                break
            }
        }
        return listStr
    }
}

