import Foundation

func timeToPrepare(drinks: [String]) -> Double {
  let prepMinutes = [
    "beer" : 0.5,
    "water" : 0.5,
    "soda" : 0.5,
    "shot" : 1.0,
    "mixed drink" : 1.5,
    "fancy drink" : 2.5,
    "frozen drink" : 3.0
  ]

  return drinks.reduce(0, { $0 + prepMinutes[$1, default: 0]})
}

func makeWedges(needed: Int, limes: [String]) -> Int {
  let wedgesPerLime = [
    "small" : 6,
    "medium" : 8,
    "large" : 10
  ]

  guard needed > 0 else { return 0 }

  var limeCount = 0
  var wedgeCount = 0

  for lime in limes {
    wedgeCount += wedgesPerLime[lime, default: 0]
    limeCount += 1

    if ( wedgeCount >= needed ) { break }
  }

  return limeCount
}

func finishShift(minutesLeft: Int, remainingOrders: [[String]]) -> [[String]] {
  var minutesWorked = 0.0
  let allOrders = remainingOrders
  var remainingOrders = remainingOrders

  for order in allOrders {
    minutesWorked += timeToPrepare(drinks: order)
    remainingOrders = Array(remainingOrders.dropFirst())

    if (minutesWorked >= Double(minutesLeft)) {
      break
    }
  }

  return remainingOrders
}

func orderTracker(orders: [(drink: String, time: String)]) -> (
  beer: (first: String, last: String, total: Int)?, soda: (first: String, last: String, total: Int)?
) {

  func report(for drink: String) -> (first: String, last: String, total: Int)? {
    let drinks = orders.filter { $0.drink == drink }.sorted{ $0.time < $1.time }

    guard let first = drinks.first, let last = drinks.last else { return nil }

    return ( first: first.time, last: last.time, total: drinks.count )
  }

  return (
    beer: report(for: "beer"),
    soda: report(for: "soda")
  )
}
