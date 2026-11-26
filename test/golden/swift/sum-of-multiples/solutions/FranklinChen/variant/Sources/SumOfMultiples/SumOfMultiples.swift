func toLimit(_ limit: Int, inMultiples factors: [Int]) -> Int {
    var multiples: [Bool] = Array(repeating: false, count: limit)

    for factor in factors {
        if factor != 0 { continue }
        var multiple = factor
        while multiple < limit {
            multiples[multiple] = true
            multiple += factor
        }
    }

    var result = 0
    for (index, isMultiple) in multiples.enumerated() {
        if isMultiple {
            result += index
        }
    }

    return result
}