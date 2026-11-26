object ResistorColorDuo {

    fun value(vararg colors: Color): Int {
        return colors.take(3)
                .map(Color::ordinal)
                .joinToString("")
                .toInt()
    }
}
