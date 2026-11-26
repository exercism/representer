object Transpose {

    fun transpose(input: List<String>): List<String> {
        var ret: MutableList<String> = mutableListOf()
        var i = 0
        while (input.any { it.length > i }) {
            var work_str = input.map {
                if (it.length > i) {
                    it[i].toChar()
                } else {
                    Char(666)
                }
            }.toCharArray().concatToString().trimEnd(Char(666)).replace(Char(666), ' ')

            ret.add(work_str)

            i++
        }
        return ret
    }
}
