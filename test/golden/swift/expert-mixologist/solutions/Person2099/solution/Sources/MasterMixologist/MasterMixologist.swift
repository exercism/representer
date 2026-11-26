func timeToPrepare(drinks: [String]) -> Double {
    let times = ["beer": 0.5, "soda": 0.5, "water": 0.5, "shot": 1.0, "mixed drink": 1.5, "fancy drink": 2.5, "frozen drink": 3]
    var prepTime = 0.0
    for drink in drinks {
        prepTime += times[drink] ?? 0.0
    }
    return prepTime
}

func makeWedges(needed: Int, limes: [String]) -> Int {
    let wedges = ["small": 6, "medium": 8, "large": 10]
    var limesVar = limes
    var made = 0
    var cut = 0
    for lime in limes {
        if made < needed && limes.isEmpty == false {
            limesVar.removeFirst()
            made += wedges[lime] ?? 0
            cut += 1
        }
    }
    return cut
}

func finishShift(minutesLeft: Int, remainingOrders: [[String]]) -> [[String]] {
    var remOrd = remainingOrders
    var minsLeft = Double(minutesLeft)
    while minsLeft > 0, remOrd.isEmpty == false {
        minsLeft -= timeToPrepare(drinks: remOrd.removeFirst())
    }
    return remOrd
}

func orderTracker(orders: [(drink: String, time: String)]) -> (
  beer: (first: String, last: String, total: Int)?, soda: (first: String, last: String, total: Int)?
) {
    var out: (beer: (first: String, last: String, total: Int)?, soda: (first: String, last: String, total: Int)?) = (beer: nil, soda: nil)
    for (drink, time) in orders {
        if drink == "beer" {
            if out.beer == nil {
                out.beer = (time, time, 0)
            }
            out.beer?.last = time
            out.beer?.total += 1
        } else if drink == "soda" {
            if out.soda == nil {
                out.soda = (time, time, 0)
            }
            out.soda?.last = time
            out.soda?.total += 1
        }
    }
    return out
}
