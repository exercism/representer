func timeToPrepare(drinks: [String]) -> Double {
    var allTime: Double = 0.0
    drinks.forEach { drink in
        switch drink{
        case "shot":
            allTime+=1.0
        case "mixed drink":
            allTime+=1.5
        case "fancy drink":
            allTime+=2.5
        case "frozen drink":
            allTime+=3.0
        default:
            allTime+=0.5
        }
        }
    return allTime
}

// timeToPrepare(drinks: ["beer", "frozen drink", "shot"])

//6small 8medium 10large
// makeWedges(needed: 25, limes: ["small", "small", "large", "medium", "small"])

func makeWedges(needed: Int, limes: [String]) -> Int {
    var wedgesCut = 0
    var limesCut = 0
    var limesGiven = limes
    while wedgesCut<needed && limesGiven.count>0{
        switch limesGiven.first{
        case "small":
            wedgesCut+=6
        case "medium":
            wedgesCut+=8
        default:
            wedgesCut+=10
        }
        limesCut += 1
        limesGiven.removeFirst()
    }
    print(wedgesCut)
    return limesCut
}

func finishShift(minutesLeft: Int, remainingOrders: [[String]]) -> [[String]] {
    var minLeft:Double = Double(minutesLeft)
    var orders = remainingOrders
    while minLeft>0.0 && orders.count>0{
        minLeft-=timeToPrepare(drinks: orders.first!)
        orders.removeFirst()
    }
    return orders
}

func orderTracker(orders: [(drink: String, time: String)]) -> (
  beer: (first: String, last: String, total: Int)?, soda: (first: String, last: String, total: Int)?
) {
    var tracker: (beer: (first: String, last: String, total: Int)?, soda: (first: String, last: String, total: Int)?)
    // var bf: (first: String, last: String, total: Int)
    orders.forEach { (drink: String, time: String) in
        switch drink{
        case "beer":
            if tracker.beer == nil {
                tracker.beer = (time,time,1)
                break
            }
            tracker.beer?.total+=1
            tracker.beer?.last = time
        case "soda":
            if tracker.soda == nil {
                tracker.soda = (time,time,1)
                break
            }
            tracker.soda?.total+=1
            tracker.soda?.last = time
        default:
            break
        }
        }
    return tracker
}