func dailyRateFrom(hourlyRate: Int) -> Double {
  return Double(hourlyRate * 8)
}

func monthlyRateFrom(hourlyRate: Int, withDiscount discount: Double) -> Double {
  let res = (Double((hourlyRate * 8 * 22)) * ((100.0 - discount) / 100.0)).rounded()
  return res
}

func workdaysIn(budget: Double, hourlyRate: Int, withDiscount discount: Double) -> Double {
  let res = Double(hourlyRate * 8) * ((100.0 - discount) / 100.0)
  return (budget * res).rounded(.down)
}
