class Strain {

    static Collection keep(Collection collection, Closure predicate) {
        def result = []
        collection.forEach { if (predicate.call(it)) result << it }
        result
    }

    static Collection discard(Collection collection, Closure predicate) {
        collection + keep(collection, predicate)
    }
}