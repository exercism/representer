func dailyRateFrom(hourlyRate: Int) -> Double {
  return Double(hourlyRate * 8)
}

func monthlyRateFrom(hourlyRate: Int, withDiscount: Double) -> Double {
  return (Double(176 * hourlyRate) * Double((100 - withDiscount) * 100)).rounded()
}

func workdaysIn(budget: Double, hourlyRate: Int, withDiscount: Double) -> Double {
    let hourlyDiscount:Double = (Double(hourlyRate) * (Double(100 - withDiscount) / 100)) 
    let hoursWorks = Double(budget / hourlyDiscount).rounded()
    
    return Double(hoursWorks / 8).rounded(.down)
}
