func timeToPrepare(drinks: [String]) -> Double {
  var totalTime = 0.0
    for drink in drinks {
        switch drink {
        case "beer", "soda", "water" : totalTime += 0.5
        case "shot" : totalTime += 1.0
        case "mixed drink": totalTime += 1.5
        case "fancy drink": totalTime += 2.5
        case "frozen drink": totalTime += 3.0
        default: continue
        }
    }
    return totalTime
}

func makeWedges(needed: Int, limes: [String]) -> Int {
    var cutLimes = 0
    var limesLeft = limes
    while cutLimes != needed && !limesLeft.isEmpty {
        let lime = limesLeft.removeFirst()
        switch lime {
        case "small": cutLimes += 6
        case " medium": cutLimes += 8
        case "large": cutLimes += 10
        default: continue
        }
    }
    return limes.count - limesLeft.count
}

func finishShift(minutesLeft: Int, remainingOrders: [[String]]) -> [[String]] {
    var orders = remainingOrders
    var minutesInShift = Double(minutesLeft)
    while minutesInShift > 0 && !orders.isEmpty {
        let order = orders.removeFirst()
        minutesInShift -= timeToPrepare(drinks: order)
    }
    return orders
}

func orderTracker(orders: [(drink: String, time: String)]) -> (
  beer: (first: String, last: String, total: Int)?, soda: (first: String, last: String, total: Int)?
) {

    var beers: [String] = []
    var soda: [String] = []
    for order in orders {
        if order.drink == "beer" {
            beers.append(order.time)
        }
        if order.drink == "soda" {
            soda.append(order.time)
        }
    }
    beers.sort()
    soda.sort()
    let beerTuple = beers.isEmpty ? nil : (first: beers.first!, last: beers.last!, total: beers.count)
    let sodaTuple = soda.isEmpty ? nil : (first: soda.first!, last: soda.last!, total: soda.count)

    return (beer: beerTuple, soda: sodaTuple)

}
