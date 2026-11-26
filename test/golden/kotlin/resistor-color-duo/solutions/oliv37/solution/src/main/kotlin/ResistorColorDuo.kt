object ResistorColorDuo {

    fun value(vararg colors: Color): Int {
        return colors.take(2)
                .map(Color::ordinal)
                .joinToString("")
                .toInt()
    }
}
