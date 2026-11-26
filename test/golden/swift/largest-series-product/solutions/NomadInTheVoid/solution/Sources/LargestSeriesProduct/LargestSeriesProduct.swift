enum NumberSeriesError: Error {
    case spanIsZeroOrNegative
    case spanLongerThanInput
    case invalidCharacter
}

class NumberSeries {
    let numbers: [Int]
    init(_ text: String) throws {
        self.numbers = try Array<Character>(text).map {
            guard let num = Int(String($0)) else {
                throw NumberSeriesError.invalidCharacter
            }
            return num
        }
    }
    
    func largestProduct(_ span: Int) throws -> Int {
        guard span > 0 else {
            throw NumberSeriesError.spanIsZeroOrNegative
        }
        guard span <= self.numbers.count else {
            throw NumberSeriesError.spanLongerThanInput
        }
        
        var ret = 0
        for i in 0..<self.numbers.count-span+1 {
            ret = max(ret, self.numbers[i..<i+span].reduce(1, *))
        }
        
        return ret
    }
    
}
