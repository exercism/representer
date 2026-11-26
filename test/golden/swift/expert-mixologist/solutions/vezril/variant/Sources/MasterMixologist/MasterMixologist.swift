// Loops? I barely know her!
func timeToPrepare(drinks: [String]) -> Double {
    let drinksPrep: [String: Double] = ["beer":0.5, "soda":0.5, "water":0.5, "shot":1.0, "mixed drink":1.5, "fancy drink":2.5, "frozen drink":3.0]
    return drinks.map { drinksPrep[$0, default: 0] }.reduce(0, { x, y in x + y })
}

// Go away loops! NO MUTATION FOR YOU. Tail recursion for the win!
func makeWedges(needed: Int, limes: [String]) -> Int {
    func prep(needed: Int, limes: [String]) -> Int {
        func prepAcc(acc: Int, needed: Int, limes: [String]) -> Int {
            let limePrep: [String: Int] = ["small": 6, "medium": 8, "large": 10]
            if(needed <= 0 || limes.isEmpty) { return acc }
            else {
                let (head, tail) = (limes.first.flatMap{ limePrep[$0] }, Array(limes.dropFirst()))
                let n = head ?? 0
                return prepAcc(acc: acc-1, needed: needed - n, limes: tail)
            }
        }
        return prepAcc(acc: 0, needed: needed, limes: limes)
    }
    return prep(needed: needed, limes: limes)
}

// Mutation is evil. Wait I'm doing Swift not Scala.
func finishShift(minutesLeft: Int, remainingOrders: [[String]]) -> [[String]] {
    
    func prep(timeRemaining: Double, orders: [[String]]) -> (Double, [[String]]) {
        func prepAcc(timeRemaining: Double, orders: [[String]]) -> (Double, [[String]]) {
            if(timeRemaining <= 0 || orders.isEmpty) { return (timeRemaining, orders) }
            else {
                let (head, tail) = (timeToPrepare(drinks: orders.first ?? []) , Array(orders.dropFirst()))
                return prepAcc(timeRemaining: timeRemaining - head, orders: tail)
            }
        }
        return prepAcc(timeRemaining: timeRemaining, orders: orders)
    }
    return prep(timeRemaining: Double(minutesLeft), orders: remainingOrders).1
}

// How to overcomplicate things with Functional Programming, a tutorial by me!
func orderTracker(orders: [(drink: String, time: String)]) -> (
  beer: (first: String, last: String, total: Int)?, soda: (first: String, last: String, total: Int)?
) {

    let beers = orders.filter{ $0.drink == "beer" }
    let sodas = orders.filter{ $0.drink == "soda" }

    let beer: (first: String, last: String, total: Int)? = {
        if(beers.isEmpty) {
            return Optional.none
        } else {
            return Optional((first: beers.min(by: {$0.time < $1.time})?.time ?? "", last: beers.max(by: {$0.time < $1.time})?.time ?? "", total: beers.count))
        }}()
    
    let soda: (first: String, last: String, total: Int)? = {
        if(sodas.isEmpty) {
            return Optional.none
        } else {
            return Optional((first: sodas.min(by: {$0.time < $1.time})?.time ?? "", last: sodas.max(by: {$0.time < $1.time})?.time ?? "", total: sodas.count))
        }}()
    
    return (beer: beer, soda: soda)
}
