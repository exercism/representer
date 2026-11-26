extension Collection where Element: AdditiveArithmetic {
    func sum() -> Element {
        reduce(.zero, +)
    }
}

func timeToPrepare(drinks: [String]) -> Double {
    let time = [
        "beer":         0.5,
        "soda":         0.5,
        "water":        0.5,
        "shot":         1.0,
        "mixed drink":  1.5,
        "fancy drink":  2.5,
        "frozen drink": 3.0
    ]
    
    return drinks.map{ (time[$0]) ?? 0.0 }.sum()
}

func still(_ needed: Int) -> Bool { 0 < needed }

func makeWedges(needed: Int, limes: [String]) -> Int {
    let wedges = ["small": 6, "medium": 8, "large": 10]
    
    var needed = needed
    var limes = limes
    
    var result = 0
    while still(needed) && !limes.isEmpty {
        let lime = limes.removeFirst()
        needed -= (wedges[lime]) ?? 0
        result += 1
    }
    
    return result
}

func finishShift(minutesLeft: Int, remainingOrders: [[String]]) -> [[String]] {
    var minutesLeft = Double(minutesLeft)
    var remainingOrders = remainingOrders
    
    while 0 < minutesLeft && !remainingOrders.isEmpty {
        let order = remainingOrders.removeFirst()
        
        minutesLeft -= timeToPrepare(drinks: order)
    }
    
    return remainingOrders
}

func orderTracker(orders: [(drink: String, time: String)]) -> (
    beer: (first: String, last: String, total: Int)?, soda: (first: String, last: String, total: Int)?
) {
    func getStats(_ times: [String]) -> (first: String, last: String, total: Int)? {
        guard !times.isEmpty else {
            return nil
        }
        
        return (times.first!, times.last!, times.count)
    }
    
    func getTimes(for drink: String, in orders: [(drink: String, time: String)]) -> [String] {
        orders.filter{$0.drink == drink}.map {$0.time}
    }
    
    let beerTimes = getTimes(for: "beer", in: orders)
    let sodaTimes = getTimes(for: "soda", in: orders)
    
    return (getStats(beerTimes), getStats(sodaTimes))
}
