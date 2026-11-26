let times = [
    "beer": 0.5,
    "soda": 0.5,
    "water": 0.5,
    "shot": 1,
    "mixed drink": 1.5,
    "fancy drink": 2.5,
    "frozen drink": 3.0
]

func timeToPrepare(drinks: [String]) -> Double {
    var time = 0.0
    for drink in drinks {
        time += times[drink, default: 0.0]
    }
    return time
}

func makeWedges(needed: Int, limes: [String]) -> Int {
    var wedgesNeeded = needed
    var remainingLimes = limes
    var limeCount = 0
    while remainingLimes.count > 0 && wedgesNeeded > 0 {
        let lime = remainingLimes.removeFirst()
        var wedges: Int
        if lime == "small" {
            wedges = 6
        } else if lime == "medium" {
            wedges = 8
        } else {
            wedges = 10
        }
        wedgesNeeded = wedgesNeeded - wedges
        limeCount += 1
    }
    return limeCount
}

func finishShift(minutesLeft: Int, remainingOrders: [[String]]) -> [[String]] {
    var minutes = Double(minutesLeft)
    var temp: [[String]] = remainingOrders
    var index = 0
    repeat {
        let time = timeToPrepare(drinks: remainingOrders[index])
        temp.remove(at: index - (remainingOrders.count - temp.count))
        minutes = minutes - time
        index = index + 1
    }
    while minutes > 0 && !temp.isEmpty && index < remainingOrders.count
    return temp
}

typealias TimedDrinks = (beer: (first: String, last: String, total: Int)?, soda: (first: String, last: String, total: Int)?)

func orderTracker(orders: [(drink: String, time: String)]) -> TimedDrinks {
    let beerOrders = orders.filter{ $0.drink == "beer"}
    let sodaOrders = orders.filter{ $0.drink == "soda"}
    let beerSorted = beerOrders.sorted{ $0.time < $1.time }
    let sodaSorted = sodaOrders.sorted{$0.time < $1.time}
    var result: TimedDrinks = (beer: nil, soda: nil)
    if let firstBeer = beerSorted.first,
        let lastBeer = beerSorted.last {
        result.beer = (first: firstBeer.time, last: lastBeer.time, total: beerOrders.count)
    }
    if let firstSoda = sodaSorted.first,
        let lastSoda = sodaSorted.last {
        result.soda = (first: firstSoda.time, last: lastSoda.time, total: sodaOrders.count)
        }
    return result
}
