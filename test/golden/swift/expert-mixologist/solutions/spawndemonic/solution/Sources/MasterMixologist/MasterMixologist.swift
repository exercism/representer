func timeToPrepare(drinks: [String]) -> Double {
  var time: Double = 0.0
  let priceDictionary: [String: Double] = ["beer": 0.5,"soda":0.5,"water":0.5,"shot":1.0,"mixed drink":1.5,
                                           "fancy drink":2.5,"frozen drink":3.0]
  for drink in drinks{
    time += priceDictionary[drink] ?? 0.0
  }
  return time
}

func makeWedges(needed: Int, limes: [String]) -> Int {
  if(needed == 0 || limes.count == 0){return 0}
  var counter = needed
  var limesNeeded : Int = 0
  let slices: [String:Int] = ["small":6,"medium":8,"large":10]
  for lime in limes{
    if(counter <= 0){continue}
    counter -= slices[lime] ?? 0
    limesNeeded += 1
  }
  return limesNeeded
}

func finishShift(minutesLeft: Int, remainingOrders: [[String]]) -> [[String]] {
  var leftovers = remainingOrders
  var time = Double(minutesLeft)
  for order in remainingOrders{
    if(time<=0){continue}
    time -= timeToPrepare(drinks: order)
    leftovers.removeFirst()
  }
  return leftovers
}

func orderTracker(orders: [(drink: String, time: String)]) -> (
  beer: (first: String, last: String, total: Int)?, soda: (first: String, last: String, total: Int)?) {
  let beerOrders = orders.filter({$0.drink == "beer" }).map({$0.time}).sorted()
  let sodaOrders = orders.filter({$0.drink == "soda" }).map({$0.time}).sorted()
  var beer: (first: String, last: String, total: Int)?, soda: (first: String, last: String, total: Int)?
  if let firstOrder = beerOrders.first , let lastOrder = beerOrders.last{
    beer = (first: firstOrder, last: lastOrder, total: beerOrders.count)
  }
  if let firstOrder = sodaOrders.first , let lastOrder = sodaOrders.last{
    soda = (first: firstOrder, last: lastOrder, total: sodaOrders.count)
  }
  //get a total for each and return both beer and soda as tuples
  return (beer:beer,soda: soda)
}
