func timeToPrepare(drinks: [String]) -> Double {
    var t : Double = 0.0
    for d in drinks {
        switch d {
        case "beer", "soda", "water": t += 0.5
        case "shot" : t += 1.0
        case "mixed drink" : t += 1.5
        case "fancy drink" : t += 2.5
        case "frozen drink" : t += 3.0
        default : t += 0.0
        }
    }
    return t
}

func makeWedges(needed: Int, limes: [String]) -> Int {
    var res = 0
    var w = 0
    for l in limes {
        if w < needed {
            res += 1
            switch l {
            case "small" : w += 6
            case "medium" : w += 8
            case "large" : w += 10
            default : continue
            }
        }
    }
    return res    
}

func finishShift(minutesLeft: Int, remainingOrders: [[String]]) -> [[String]] {
    var orders = remainingOrders
    var m = Double(minutesLeft)
    repeat {
        let order = orders.remove(at: 0)
        let t = timeToPrepare(drinks: order)
        m -= t
    } while m > 0 && orders.count > 0
    return orders
}

func orderTracker(orders: [(drink: String, time: String)]) -> (
  beer: (first: String, last: String, total: Int)?, soda: (first: String, last: String, total: Int)?
) {
    var beer : (first: String, last: String, total: Int) = ("", "", 0)
    var soda : (first: String, last: String, total: Int) = ("", "", 0)
    for o in orders {
        if o.drink == "beer" {
            beer.total += 1
            if beer.total == 1 {
                beer.first = o.time
                beer.last = o.time
            } else {
                if o.time < beer.first {beer.first = o.time}
                if o.time > beer.last {beer.last = o.time}
            }
        } else if o.drink == "soda" {
            soda.total += 1
            if soda.total == 1 {
                soda.first = o.time
                soda.last = o.time
            } else {
                if o.time < soda.first {soda.first = o.time}
                if o.time > soda.last {soda.last = o.time}
            }
        }
    }
    var b : (first: String, last: String, total: Int)? = nil
    var s : (first: String, last: String, total: Int)? = nil
    if beer.total > 0 {b = beer}
    if soda.total > 0 {s = soda}
    return (beer: b, soda: s)
}
