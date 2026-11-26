class Accumulate {

    static accumulate(Collection collection, Closure func) {
        def result = []
        collection.each { result << func(it) }
        result
    }

}
