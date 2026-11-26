object ResistorColorDuo {

    fun value(vararg colors: Color): Int {
        val result : StringBuilder = StringBuilder()
        for (c in colors.take(3)) result.append(c.ordinal)
        return result.toString().toInt()
    }

}
