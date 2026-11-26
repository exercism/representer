func toLimit(_ limit: Int, inMultiples mult: [Int]) -> Int {
    let multiples = (0..<limit).filter{ (num: Int) -> Bool in
        mult.contains { num.isMultiple(of: $0) }
    }
    return multiples.reduce(0, +)
}