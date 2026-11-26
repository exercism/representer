func timeToPrepare(drinks: [String]) -> Double {
    var time = 0.0
    for s in drinks {
        if s == "beer" || s == "soda" || s == "water" {
            time += 0.5
        } else if s == "shot" {
            time += 1
        } else if s == "mixed drink" {
            time += 1.5
        } else if s == "fancy drink" {
            time += 2.5
        } else if s == "frozen drink" {
            time += 3
        }
    }
    return time
}

func makeWedges(needed: Int, limes: [String]) -> Int {
    var remain = needed
    var count = 0
    for s in limes {
        if remain > 0 {
            count += 1
        }
        if s == "small" {
            remain -= 6
        } else if s == "medium" {
            remain -= 8
        } else if s == "large" {
            remain -= 10
        }
        
    }
    return count
}

func finishShift(minutesLeft: Int, remainingOrders: [[String]]) -> [[String]] {
    var array: [[String]] = []
    var remain = minutesLeft * 10

    for s in remainingOrders {
        let time = Int(timeToPrepare(drinks: s) * 10 )
        if remain > 0 {
            
            remain -= time
        } else{
            array.append(s)
        }
        
    }
    return array
}

func orderTracker(orders: [(drink: String, time: String)]) -> (
  beer: (first: String, last: String, total: Int)?, soda: (first: String, last: String, total: Int)?
) {
    var beer: (first: String, last: String,total: Int)? = nil
    var soda: (first: String,last: String,total: Int)? = nil
    for s in orders {
        if s.drink == "beer" {
            if beer == nil {
                beer = (first: s.time, last: s.time, total: 1)
            } else{
                beer!.last = s.time
                beer!.total = beer!.total + 1
            }
        } else if s.drink == "soda" {
            if soda == nil {
                soda = (first: s.time, last: s.time, total: 1)
            } else {
                soda!.last = s.time
                soda!.total = soda!.total + 1
            }
            
        }
    }
    return (beer: beer, soda: soda)
}
