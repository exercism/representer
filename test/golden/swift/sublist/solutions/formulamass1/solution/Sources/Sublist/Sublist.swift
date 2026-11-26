//Solution goes in Sources
enum Judgement {
    case equal
    case sublist
    case superlist
    case unequal
    
}

func classifier(listOne: [Int], listTwo: [Int]) -> Judgement {
    // If both arrays are identical, then they are equal
    if listOne == listTwo {
        return .equal
    // If listOne is empty but listTwo is not, then listOne is a sublist
    } else if listOne.isEmpty && !listTwo.isEmpty {
        return .sublist
    // If listOne is not empty but listTwo is, then listOne is a superlist
    } else if !listOne.isEmpty && listTwo.isEmpty {
        return .superlist
    // If listOne is smaller than listTwo, then it might be a sublist
    } else if listOne.count < listTwo.count {
        for (index, _) in listTwo.enumerated() {
            // Make sure the index does not surpass the accepted limit
            if index <= listTwo.count - listOne.count {
                // Slice listTwo by the length of listOne
                let testArray = Array(listTwo[index..<listTwo.index(index, offsetBy: listOne.count)])
                // Compare the slice to that of listOne
                if testArray == listOne {
                    return .sublist
                }
            }
        }
    // If listOne is larger than listTwo, then it might be a superlist
    } else if listOne.count > listTwo.count {
        for (index, _) in listOne.enumerated() {
            // Make sure the index does not surpass the accepted limit
            if index <= listOne.count - listTwo.count {
                // Slice listOne by the length of listTwo
                let testArray = Array(listOne[index..<listOne.index(index, offsetBy: listTwo.count)])
                // Compare the slice to that of listTwo
                if testArray == listTwo {
                    return .superlist
                }
            }
        }
    }
    // If all else fails, both arrays are unequal
    return .unequal
}

