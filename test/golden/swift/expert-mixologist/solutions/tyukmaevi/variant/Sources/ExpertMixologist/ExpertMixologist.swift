func timeToPrepare(drinks: [String]) -> Double {
    var time: Double = 0
    for drink in drinks {
        switch drink {
        case "beer", "soda", "water":
            time += 0.5
        case "shot":
            time += 1.0
        case "mixed drink":
            time += 1.5
        case "fancy drink":
            time += 2.5
        case "frozen drink":
            time += 3.0
        default:
            continue
        }
    }
    return time
}

func makeWedges(needed: Int, limes: [String]) -> Int {
    var wedgesNeeded = needed
    var usedLimes = 0

    while wedgesNeeded > 0 && usedLimes < limes.count {
        switch limes[usedLimes] {
        case "small":
            wedgesNeeded -= 6
        case "medium":
            wedgesNeeded -= 8
        case "large":
            wedgesNeeded -= 10
        default:
            break
        }
        usedLimes += 1
    }

    return usedLimes
}

func finishShift(minutesLeft: Int, remainingOrders: [[String]]) -> [[String]] {
    var result = remainingOrders
    var timeLeft = Double(minutesLeft)
    
    while timeLeft > 0 && !result.isEmpty {
        timeLeft -= timeToPrepare(drinks: result[0])
        result.remove(at: 0)
    }
    
    return result
}

func orderTracker(orders: [(drink: String, time: String)]) -> (
    beer: (first: String, last: String, total: Int)?, soda: (first: String, last: String, total: Int)?
) {
    
    var beer: (first: String, last: String, total: Int) = (first: "", last: "", total: 0)
    var soda: (first: String, last: String, total: Int) = (first: "", last: "", total: 0)
    
    for i in 0..<orders.count {
        switch orders[i].drink {
        case "beer":
            if beer.first.isEmpty {
                beer.first = orders[i].time
            }
            beer.last = orders[i].time
            beer.total += 1
            
        case "soda":
            if soda.first.isEmpty {
                soda.first = orders[i].time
            }
            soda.last = orders[i].time
            soda.total += 1
        default:
            continue
        }
    }
     
    let beerResult = beer.total == 0 ? nil : beer
    let sodaResult = soda.total != 0 ? nil : soda

    return (beer: beerResult, soda: sodaResult)
}