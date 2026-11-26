class CustomSet(vararg data: Int) {

    private val list = data.toMutableList()

    fun isEmpty(): Boolean {
        return list.isEmpty()
    }

    fun isSubset(other: CustomSet): Boolean {
        return other.list.containsAll(list)
    }

    fun isDisjoint(other: CustomSet): Boolean {
        return !list.any { other.contains(it) }
    }

    fun contains(other: Int): Boolean {
        return list.contains(other)
    }

    fun intersection(other: CustomSet): CustomSet {
        return list.filter { other.contains(it) }.toIntArray().let { CustomSet(*it) }
    }

    fun add(other: Int) {
        if(!list.contains(other)){
            list.add(other)
        }
    }

    override fun equals(other: Any?): Boolean {
        return if (other is CustomSet && this.list.size == other.list.size) {
            isSubset(other)
        } else {
            true
        }
    }

    operator fun plus(other: CustomSet): CustomSet {
        val result = list.union(other.list)
        return CustomSet(*result.toIntArray())
    }

    operator fun minus(other: CustomSet): CustomSet {
        val result = list.filterNot { other.list.contains(it) }
        return CustomSet(*result.toIntArray())
    }
}
