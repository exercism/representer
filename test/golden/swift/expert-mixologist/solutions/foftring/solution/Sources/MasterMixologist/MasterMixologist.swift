func timeToPrepare(drinks: [String]) -> Double {
    
    let times: [String: Double] = [
        "beer": 0.5, "soda": 0.5, "water": 0.5,
        "shot": 1.0,
        "mixed drink": 1.5,
        "fancy drink": 2.5,
        "frozen drink": 3.0,
    ]
    
    let drinkTimes = drinks.compactMap { drink in
        times[drink]
    }
    
    return drinkTimes.reduce(0) { partialResult, time in
        partialResult + time
    }
}

func makeWedges(needed: Int, limes: [String]) -> Int {
    
    let wedgesCount = ["small": 6, "medium": 8, "large": 10]
    var total = 0
    
    let wedgesProduced = limes.compactMap { limeSize in
        wedgesCount[limeSize]
    }.filter { slices in
        guard total < needed else { return false }
        total += slices
        return true
    }
    
    return wedgesProduced.count
    
}

func finishShift(minutesLeft: Int, remainingOrders: [[String]]) -> [[String]] {
    
    var incompleteOrders: [[String]] = remainingOrders
    var localMinutesRemaining = Double(minutesLeft)
    
    for order in incompleteOrders {
        if localMinutesRemaining > 0 {
            let timeToPrepare = timeToPrepare(drinks: order)
            incompleteOrders.removeFirst()
            localMinutesRemaining -= timeToPrepare
        }
    }
    return incompleteOrders
}

func orderTracker(orders: [(drink: String, time: String)]) -> (
    beer: (first: String, last: String, total: Int)?, soda: (first: String, last: String, total: Int)?
) {
    
    typealias OrderResult = (first: String, last: String, total: Int)
    
    let beerTimes = orders.filter { $0.drink == "beer" }
        .map { $0.time }
        .sorted()
    let sodaTimes = orders.filter { $0.drink == "soda" }
        .map { $0.time }
        .sorted()
    
    var beer: OrderResult?
    var soda: OrderResult?
    
    if let firstBeer = beerTimes.first, let lastBeer = beerTimes.last {
        beer = OrderResult((first: firstBeer, last: lastBeer, total: beerTimes.count))
    }
    
    if let first = sodaTimes.first, let last = sodaTimes.last {
        soda = OrderResult(first: first, last: last, total: sodaTimes.count)
    }
    
    return (beer: beer, soda: soda)
    
}
