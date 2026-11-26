func timeToPrepare(for drinks: [String]) -> Double {
    let durations: [String: Double] =  [
        "beer": 0.5,
        "soda": 0.5,
        "water": 0.5,
        "shot": 1.0,
        "mixed drink": 1.5,
        "fancy drink": 2.5,
        "frozen drink": 3.0
    ]
    return drinks.reduce(0.0, {duration, drink in duration + (durations[drink] ?? 0.0)})
}

func makeWedges(needed: Int, limes: [String]) -> Int {
    guard needed > 0 else { return 0 }
    let wedgesFor: [String: Int] = [
        "small": 6,
        "medium": 8,
        "large": 10
    ]
    var cutLimes = 0
    var wedgesStillNeeded = needed
    for lime in limes {
        guard let wedgesFromThisLime = wedgesFor[lime] else { fatalError("Unknown lime size.")  }
        guard wedgesStillNeeded >= wedgesFromThisLime else { return cutLimes + 1 }
        cutLimes += 1
        wedgesStillNeeded -= wedgesFromThisLime
    }
    return cutLimes
}

func finishShift(minutesLeft: Int, remainingOrders: [[String]]) -> [[String]] {
    var remainingMinutes: Double = Double(minutesLeft)
    var timeForNextOrder = timeToPrepare(for: remainingOrders.first!)
    var orderIndex = 0
    while remainingMinutes >= timeForNextOrder {
        guard orderIndex < remainingOrders.count else { return [] }
        remainingMinutes -= timeForNextOrder
        timeForNextOrder = timeToPrepare(for: remainingOrders[orderIndex])
        orderIndex += 1
    }
    return Array(remainingOrders[orderIndex ..< remainingOrders.count])
}

typealias Order = (drink: String, time: String)

typealias TrackedOrder = (first: String, last: String, total: Int)

typealias TrackedBeerAndSoda = (
    beer: TrackedOrder?, soda: TrackedOrder?
)

func orderTracker(orders: [Order]) -> TrackedBeerAndSoda {
    var trackedBeerAndSoda: TrackedBeerAndSoda = (beer: nil, soda: nil)
    
    func trackOrder(order: Order, into trackedOrder: inout TrackedOrder?) {
        guard trackedOrder != nil else { return trackedOrder = (first: order.time, last: order.time, total: 1) }
        trackedOrder!.total += 1
        trackedOrder!.first = order.time < trackedOrder!.first ? order.time : trackedOrder!.first
        trackedOrder!.last = order.time > trackedOrder!.last  ? order.time : trackedOrder!.last
    }
    
    for order in orders {
        switch order.drink {
        case "beer":
            trackOrder(order: order, into: &trackedBeerAndSoda.beer)
        case "soda":
            trackOrder(order: order, into: &trackedBeerAndSoda.soda)
        default:
            continue
        }
    }
    
    return trackedBeerAndSoda
}
