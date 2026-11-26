package cars

// CalculateWorkingCarsPerHour calculates how many working cars are
// produced by the assembly line every hour.
func CalculateWorkingCarsPerHour(productionRate int, successRate float64) float64 {
	workingCars := float64(productionRate) * (successRate / 100)
	return workingCars
}

// CalculateWorkingCarsPerMinute calculates how many working cars are
// produced by the assembly line every minute.
func CalculateWorkingCarsPerMinute(productionRate int, successRate float64) int {
	workingCarsPerMinute := int((float64(productionRate) * (successRate / 100)) / 60)
    return workingCarsPerMinute
}

// CalculateCost works out the cost of producing the given number of cars.
func CalculateCost(carsCount int) uint {
	carsCost := uint(((carsCount % 10) * 10000) + ((carsCount / 10) * 95000))
    return carsCost
}
