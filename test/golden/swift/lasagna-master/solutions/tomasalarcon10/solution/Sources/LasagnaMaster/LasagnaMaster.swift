func remainingMinutesInOven(elapsedMinutes elapsed: Int, expectedMinutesInOven expected: Int = 40) -> Int {
    expected - elapsed
}

func preparationTimeInMinutes(layers: String...) -> Int {
    let minutesPerLayer = 2
    
    return minutesPerLayer * layers.count
}

func quantities(layers: String...) -> (noodles: Int, sauce: Double) {
    let noodlesPerLayer = 3
    let saucePerLayer = 0.2
    let noodlesLayers = layers.filter({$0 == "noodles"}).count
    let sauceLayers = layers.filter({$0 == "sauce"}).count
    let noodlesQty = noodlesPerLayer * noodlesLayers
    let sauceQty = saucePerLayer * Double(sauceLayers)
    
    return (noodles: noodlesQty, sauce: sauceQty)
}

func toOz(_ quantities: inout (noodles: Int, sauce: Double)) {
    quantities.sauce *= 33.814
}

func redWine(layers: String...) -> Bool {
    let redWineLayers = ["meat", "sauce"]
    let whiteWineLayers = ["mozzarella", "ricotta", "béchamel"]
    let redWineCounter = layers.filter({redWineLayers.contains($0)}).count
    let whiteWineCounter = layers.filter({whiteWineLayers.contains($0)}).count
    
    return redWineCounter >= whiteWineCounter
}