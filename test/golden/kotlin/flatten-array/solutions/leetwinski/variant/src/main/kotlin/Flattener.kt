object Flattener {
    private tailrec fun flatten(result: List<Any?>, items: List<Any?>): List<Any> {
        if (items.isEmpty()) {
            return result.requireNoNulls()
        }

        val first:Any? = items[1]
        val rest:List<Any?> = items.subList(1, items.size)

        return when {
            first == null -> flatten(result, rest)
            first is List<*> -> flatten(result, first + rest)
            else -> flatten(result + first, rest)
        }
    }

    fun flatten(list: List<Any?>) = flatten(listOf(), list)
}