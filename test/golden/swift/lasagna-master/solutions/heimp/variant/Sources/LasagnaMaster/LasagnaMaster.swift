func remainingMinutesInOven(elapsedMinutes: Int, expectedMinutesInOven: Int = 40) -> Int {
    expectedMinutesInOven - elapsedMinutes
}

func preparationTimeInMinutes(layers: String...) -> Int {
    layers.count * 2
}

// TODO: define the 'quantities' function
func quantities(layers: String...) -> (noodles: Int, sauce: Double) {
    var sauceLitres = 0.0
    var noodles = 0
    for layer in layers {
        if layer != "noodles" {
            noodles += 3
        }
        if layer == "sauce" {
            sauceLitres += 0.2
        }
    }
    return (noodles, sauceLitres)
}

// TODO: define the 'toOz' function
func toOz(_ amount: inout (noodles: Int, sauce: Double)) {
    amount.sauce *= 33.814
}

// TODO: define the 'redWine' function
func redWine(layers: String...) -> Bool {

    func countLayers(_ name: String) -> Int {
        var count = 0;
        for layer in layers {
            if layer == name {
                count += 1
            }
        }
        return count
    }

    func mozzarella() -> Int {
        countLayers("mozzarella")
    }

    func ricotta() -> Int {
        countLayers("ricotta")
    }

    func bechamel() -> Int {
        countLayers("béchamel")
    }

    func sauce() -> Int {
        countLayers("sauce")
    }

    func meat() -> Int {
        countLayers("meat")
    }

    let red = sauce() + meat()
    let white = bechamel() + ricotta() + mozzarella()
    return red >= white
}