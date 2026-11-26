enum ListCategory {
    case equal, unequal, sublist, superlist
}

func classifier(listOne: [Int], listTwo: [Int]) -> ListCategory {
    if listOne.count == listTwo.count {
        return equal(listOne: listOne, listTwo: listTwo) ? .equal : .unequal
    } else if listOne.count > listTwo.count {
        return superlist(larger: listOne, smaller: listTwo) ? .superlist : .unequal
    } else {
        return superlist(larger: listTwo, smaller: listOne) ? .sublist : .unequal
    }
}

private func equal(listOne: [Int], listTwo: [Int]) -> Bool {
    for (index, element) in listOne.enumerated() {
        if listTwo[index] != element {
            return false
        }
    }
    return true
}

private func superlist(larger: [Int], smaller: [Int]) -> Bool {
    guard !smaller.isEmpty else {
        return true
    }

    var largerIndex = 0
    var smallerIndex = 0
    while largerIndex < larger.count - 1 {
        while smallerIndex < smaller.count {
            if larger[largerIndex + smallerIndex] == smaller[smallerIndex] {
                if smallerIndex == smaller.count - 1 {
                    return true
                }
                smallerIndex += 1
            } else {
                break
            }
        }
        smallerIndex = 0
        largerIndex += 1
    }
    return false
}
