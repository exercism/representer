//Solution goes in Sources

func toLimit(_ limit: Int, inMultiples multiples: [Int]) -> Int {
    (1..<limit).filter { number in
        multiples.contains { multiple in
            number.isMultiple(of: multiple)
        }
    }.reduce(0, +)
}