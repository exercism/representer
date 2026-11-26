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
        break
    }
  }
  return time
}

func makeWedges(needed: Int, limes: [String]) -> Int {
  var usedLimes = 0
  var slices = 0
  guard needed == 0 || limes.isEmpty || usedLimes >= limes.count else {
    while (slices <= needed && usedLimes < limes.count) {
      for lime in limes {
        if (slices <= needed && usedLimes < limes.count) {
          switch lime {
          case "small":
            slices += 6
            usedLimes += 1
          case "medium":
            slices += 8
            usedLimes += 1
          case "large":
            slices += 10
            usedLimes += 1
          default:
            break
          }
        }
      }
    }
    return usedLimes
  }
  return usedLimes
}

func finishShift(minutesLeft: Int, remainingOrders: [[String]]) -> [[String]] {
  var minutesTaken = 0.0
  var ordersLeft: [[String]] = []
  for order in remainingOrders {
    if (minutesTaken < Double(minutesLeft)) {
      minutesTaken += timeToPrepare(drinks: order)
    } else {
      ordersLeft.append(order)
    }
  }
  return ordersLeft
}

func orderTracker(orders: [(drink: String, time: String)]) -> (
  beer: (first: String, last: String, total: Int)?, soda: (first: String, last: String, total: Int)?
) {
  var beerResult: (first: String, last: String, total: Int) = ("", "", 0)
  var sodaResult: (first: String, last: String, total: Int) = ("", "", 0)

  for order in orders {
    let (drink, time) = order
    switch drink {
    case "beer":
      let (beerTime, _, beerTotal) = beerResult
      if (beerTotal == 0) {
        beerResult = (time, time, beerTotal + 1)
      } else {
        beerResult = (beerTime, time, beerTotal + 1)
      }
    case "soda":
      let (sodaTime, _, sodaTotal) = sodaResult
      if (sodaTotal == 0) {
        sodaResult = (time, time, sodaTotal + 1)
      } else {
        sodaResult = (sodaTime, time, sodaTotal + 1)
      }
    default:
      break
    }
  }
  let (_, _, beerAmount) = beerResult
  let (_, _, sodaAmount) = sodaResult

  return (beerAmount > 0 ? beerResult : nil, sodaAmount > 0 ? sodaResult : nil)
}
