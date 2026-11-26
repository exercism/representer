func canIBuy(vehicle: String, price: Double, monthlyBudget: Double) -> String {
  let monthlyPayment: Double = price / 60.0
  if monthlyPayment <= monthlyBudget {
    return "Yes! I'm getting a \(vehicle)"
  }
  if monthlyPayment <= monthlyBudget * 1.1 {
    return "I'll have to be frugal if I want a \(vehicle)"
  }
  return "Darn! No \(vehicle) for me"
}

func licenseType(numberOfWheels wheels: Int) -> String {
  if wheels == 2 || wheels == 3 {
    return "You will need a motorcycle license for your vehicle"
  }
  if wheels == 4 || wheels == 6 {
    return "You will need an automobile license for your vehicle"
  }
  if wheels == 18 {
    return "You will need a commercial trucking license for your vehicle"
  }
  return "We do not issue licenses for those types of vehicles"
}

func calculateResellPrice(originalPrice: Int, yearsOld: Int) -> Int {
  if yearsOld < 3 {
    return Int(Double(originalPrice) * 0.8)
  }
  if yearsOld >= 10 {
    return Int(Double(originalPrice) * 0.5)
  }
  return Int(Double(originalPrice) * 0.7)
}
