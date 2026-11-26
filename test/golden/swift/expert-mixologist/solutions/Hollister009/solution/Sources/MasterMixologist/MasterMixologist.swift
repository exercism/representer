typealias DrinkTrack = (first: String, last: String, total: Int)?

func timeToPrepare(drinks: [String]) -> Double {
    let dictionary = [
        "beer": 0.5,
        "soda": 0.5,
        "water": 0.5,
        "shot": 1.0,
        "mixed drink": 1.5,
        "fancy drink": 2.5,
        "frozen drink": 3.0
    ]

    return drinks.reduce(0, {
        $0 + (dictionary[$1] ?? 0)
    })
}

func makeWedges(needed: Int, limes: [String]) -> Int {
    if needed == 0 || limes.count == 0 { return 0 } 
    let wedges: [String:Int] = [
        "small": 6,
        "medium": 8,
        "large": 10
    ]
    let maxIndex = limes.count - 1
    var cutted = 0
    var count = 0
    
    repeat {
        cutted += wedges[limes[count]]!
        count += 1
    } while cutted < needed && count < maxIndex
    
    return cutted < needed ? count + 1 : count
}

func finishShift(minutesLeft: Int, remainingOrders: [[String]]) -> [[String]] {
    var minutesLeft = Double(minutesLeft)
    var remainingOrders = remainingOrders
    
    repeat {
        let nextDrinks = remainingOrders[0]
        minutesLeft -= timeToPrepare(drinks: nextDrinks)
        remainingOrders.removeFirst()
    } while minutesLeft > 0 && remainingOrders.count != 0
    
    return remainingOrders
}

func orderTracker(orders: [(drink: String, time: String)]) -> (beer: DrinkTrack, soda: DrinkTrack) {
    var result: (beer: DrinkTrack, soda: DrinkTrack) = (beer: nil, soda: nil)

    for order in orders {
        let (drink, time) = order
        
        if drink == "beer" {
            if result.beer == nil {
                result.beer = DrinkTrack((first: time,
                                          last: time,
                                          total: 1))
            } else {
                result.beer = DrinkTrack((first: result.beer?.first ?? time,
                                          last: time,
                                          total: (result.beer?.total ?? 0) + 1))
            }

            continue
        }
        
        if drink == "soda" {
            if result.soda == nil {
                result.soda = DrinkTrack((first: time,
                                          last: time,
                                          total: 1))
            } else {
                result.soda = DrinkTrack((first: result.soda?.first ?? time,
                                          last: time,
                                          total: (result.soda?.total ?? 0) + 1))
            }

            continue
        }
    }
    
    return result
}


