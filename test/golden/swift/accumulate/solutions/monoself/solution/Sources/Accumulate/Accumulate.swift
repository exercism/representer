//Solution goes in Sources
extension Collection {
    func accumulate<T>(_ operation: (Element) -> T) -> [T] {
        var result = [T]()
        for e in self {
            result.append(operation(e))
        }
        return result
    }
}