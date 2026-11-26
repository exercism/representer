// TODO: define the 'remainingMinutesInOven' function
func remainingMinutesInOven(elapsedMinutes: Int, expectedMinutesInOven: Int = 40) -> Int {
    return expectedMinutesInOven - elapsedMinutes
}
// TODO: define the 'preparationTimeInMinutes' function
func preparationTimeInMinutes(layers: String...) -> Int {
    return layers.count * 2
}
// TODO: define the 'quantities' function
func quantities(layers: String...) -> (noodles: Int, sauce: Double) {
    let noodles = layers.filter{ $0 == "noodles" }.count * 3
    let sauce = Double(layers.filter{ $0 == "sauce" }.count) * 0.2

    return (noodles: noodles, sauce: sauce)
}
// TODO: define the 'toOz' function
func toOz(_ amount: inout (noodles: Int, sauce: Double)) {
    amount = (noodles: amount.noodles, sauce: amount.sauce * 33.814)
}
// TODO: define the 'redWine' function
func redWine(layers: String...) -> Bool {
    func mozzarellaCount(_ layers: [String]) -> Int {
        return layers.reduce(0, { $1 == "mozzarella" ? $0 + 1 : $0})
    }
    func ricottaCount(_ layers: [String]) -> Int {
        return layers.reduce(0, { $1 == "ricotta" ? $0 + 1 : $0})
    }
    func bechamelCount(_ layers: [String]) -> Int {
        return layers.reduce(0, { $1 == "béchamel" ? $0 + 1 : $0})
    }
    func sauceCount(_ layers: [String]) -> Int {
        return layers.reduce(0, { $1 == "sauce" ? $0 + 1 : $0})
    }
    func meatCount(_ layers: [String]) -> Int {
        return layers.reduce(0, { $1 == "meat" ? $0 + 1 : $0})
    }

    if (mozzarellaCount(layers) + ricottaCount(layers) + bechamelCount(layers)) > (sauceCount(layers) + meatCount(layers)) { return false }
    else { return true}
}