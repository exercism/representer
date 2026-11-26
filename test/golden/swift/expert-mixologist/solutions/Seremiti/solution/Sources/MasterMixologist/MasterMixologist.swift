func timeToPrepare(drinks: [String]) -> Double {
  var time = 0.0
  for drink in drinks {
    switch drink {
    case "beer", "soda", "water":
      time += 0.5
    case "shot":
      time += 1.0
    case "mixed drink":
      time += 1.5
    case "fancy drink":
      time += 2.5
    case "frozen drink":
      time += 3.0
    default:
      time += 0
    }
  }
  return time
}
func makeWedges(needed: Int, limes: [String]) -> Int {
  var neededN = needed
  var cutN = 0
  while neededN > 0 && cutN < limes.count {
    let lime = limes[cutN]
    switch lime {
    case "small":
      neededN -= 6
    case "medium":
      neededN -= 8
    case "large":
      neededN -= 10
    default:
      neededN -= 0
    }
    cutN += 1
  }
  return cutN
}

func finishShift(minutesLeft: Int, remainingOrders: [[String]]) -> [[String]] {
  var orders = remainingOrders
  var timeToWork = Double(minutesLeft)
  repeat {
    let order = orders.removeFirst()
    timeToWork -= timeToPrepare(drinks: order)
  } while timeToWork > 0 && !orders.isEmpty
  return orders
}

func orderTracker(orders: [(drink: String, time: String)]) -> (
  beer: (first: String, last: String, total: Int)?, soda: (first: String, last: String, total: Int)?
) {
  var beer = (count: 0, first: "", last: "")
  var soda = (count: 0, first: "", last: "")

  for (drink, time) in orders {
    if drink == "beer" {
      beer.count += 1
      if beer.first.isEmpty { beer.first = time }
      beer.last = time
    } else if drink == "soda" {
      soda.count += 1
      if soda.first.isEmpty { soda.first = time }
      soda.last = time
    }
  }
  
  return (
    beer: beer.count > 0 ? (first: beer.first, last: beer.last, total: beer.count) : nil,
    soda: soda.count > 0 ? (first: soda.first, last: soda.last, total: soda.count) : nil
    )
}
