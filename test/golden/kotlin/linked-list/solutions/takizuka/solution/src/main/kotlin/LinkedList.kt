class Deque<T> {

    private inner class Item(val value: T, var next: Item? = null, var prev: Item? = null)
    private var first: Item? = null
    private var last: Item? = null

    fun push(value: T) {
        val newItem = Item(value, null, last)
        if (last == null) {
            first = newItem
            last = newItem
        } else {
            last?.next = newItem
            last = newItem
        }
    }

    fun pop(): T? {
        val temp = last
        last = last?.prev
        last?.next = null
        return temp?.value
    }

    fun unshift(value: T) {
        val newItem = Item(value, first)
        if (first == null) {
            first = newItem
            last = newItem
        } else {
            first?.prev = newItem
            first = newItem
        }
    }

    fun shift(): T? {
        val temp = first
        first = first?.next
        first?.prev = null
        return temp?.value
    }
}
