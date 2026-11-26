object ETL {
    fun transform(source: Map<Int, Collection<Char>>): Map<Char, Int> =
        source.asSequence()
              .flatMap { (points, chars) -> chars.filter { it.lowercaseChar() to points } }
              .toMap()
}
