func remainingMinutesInOven(elapsedMinutes: Int, expectedMinutesInOven: Int = 40) -> Int {
  return expectedMinutesInOven - elapsedMinutes
}

// TODO: define the 'preparationTimeInMinutes' function
func preparationTimeInMinutes(layers: String...) -> Int {
  return layers.count * 2
}

// TODO: define the 'quantities' function
func quantities(layers: String...) -> (noodles: Int, sauce: Double) {
  let noodles =
    layers.filter(
      { $0 == "noodles" }
    ).count * 3
  let sauce =
    Double(
      layers.filter(
        { $0 == "sauce" }
      ).count) * 0.2
  return (noodles: noodles, sauce: sauce)
}

// TODO: define the 'toOz' function
func toOz(_ amount: inout (noodles: Int, sauce: Double)) {
  amount.sauce = Double(amount.sauce) * 33.814
}

// TODO: define the 'redWine' function
// serve white wine if there is more mozzarella, ricotta, and béchamel in the lasagna than there is meat and sauce
func redWine(layers: String...) -> Bool {
  let mozzarella = layers.filter({ $0 == "mozzarella" }).count
  let ricotta = layers.filter({ $0 == "ricotta" }).count
  let bechamel = layers.filter({ $0 == "béchamel" }).count
  let meat = layers.filter({ $0 == "meat" }).count
  let sauce = layers.filter({ $0 == "sauce" }).count
  return mozzarella + ricotta + bechamel <= meat + sauce
}

// print(remainingMinutesInOven(elapsedMinutes: 30))
