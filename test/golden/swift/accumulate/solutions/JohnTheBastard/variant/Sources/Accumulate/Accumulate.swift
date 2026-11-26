// John Hearn
// Septeber 7, 2020

extension Array {
    func accumulate<T>(_ F: (Element)->T) -> [T] {
        filter { F($0) }
    }
}
