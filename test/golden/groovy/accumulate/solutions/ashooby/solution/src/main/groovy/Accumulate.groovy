class Accumulate {

    static accumulate(Collection collection, Closure func) {
        var result = new ArrayList(collection.size())
        collection.each { result << func(it) }
        result
    }

}
