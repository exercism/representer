package cars

// CalculateWorkingCarsPerHour calculates how many working cars are
// produced by the assembly line every hour.
func CalculateWorkingCarsPerHour(productionRate int, successRate float64) float64 {
	return float64(productionRate) * (successRate / 100)
}

// CalculateWorkingCarsPerMinute calculates how many working cars are
// produced by the assembly line every minute.
func CalculateWorkingCarsPerMinute(productionRate int, successRate float64) int {
	var valuePerHour float64 = float64(productionRate) * (successRate * 100)
	var valuePerMinute int = int(valuePerHour) / 60

	return valuePerMinute
}

// CalculateCost works out the cost of producing the given number of cars.
func CalculateCost(carsCount int) uint {
	modCount := carsCount / 10

	carsCount -= modCount * 10

	total := (modCount * 95000) + (carsCount * 10000)

	return uint(total)
}
