func timeToPrepare(drinks: [String]) -> Double {
  var total = 0.0
  for drink in drinks {
    switch drink {
      case "beer", "soda", "water":
        total += 0.5
      case "shot":
        total += 1.0
      case "mixed drink":
        total += 1.5
      case "fancy drink":
        total += 2.5
      case "frozen drink":
        total += 3.0
      default:
        total += 0.0
    }
  }
  return total
}

func makeWedges(needed: Int, limes: [String]) -> Int {
  var limes = limes
  var wedges = 0
  var usedLimes = 0
  while wedges < needed && limes.count > 0 {
    switch limes[0] {
      case "small":
        wedges += 6
      case "medium":
        wedges += 8
      case "large":
        wedges += 10
      default:
        wedges += 0
    }
    limes.remove(at: 0)
    usedLimes += 1
  }
  return usedLimes
}

func finishShift(minutesLeft: Int, remainingOrders: [[String]]) -> [[String]] {
  var remainingOrders = remainingOrders
  var minutesLeft = Double(minutesLeft)
  repeat {
    let minutesForOrder = timeToPrepare(drinks: remainingOrders[0])
    minutesLeft -= minutesForOrder
    remainingOrders.remove(at: 0)
  } while minutesLeft > 0 && remainingOrders.count > 0
  return remainingOrders
}

func orderTracker(orders: [(drink: String, time: String)]) -> (
  beer: (first: String, last: String, total: Int)?, soda: (first: String, last: String, total: Int)?
) {
  var drinks: [String: (first: String, last: String, total: Int)] = [:]
  for order in orders {
    drinks[order.drink, default: (first: order.time, last: order.time, total: 0)].last = order.time
    drinks[order.drink]?.total += 1
  }
  let beer = drinks["beer"]
  let soda = drinks["soda"]
  return (beer: beer, soda: soda)
}
