package cars

// CalculateWorkingCarsPerHour calculates how many working cars are
// produced by the assembly line every hour.
func CalculateWorkingCarsPerHour(productionRate int, successRate float64) float64 {
	return (float64(productionRate) * successRate) / 100
}

// CalculateWorkingCarsPerMinute calculates how many working cars are
// produced by the assembly line every minute.
func CalculateWorkingCarsPerMinute(productionRate int, successRate float64) int {
    var carsPerHour = CalculateWorkingCarsPerHour(productionRate, successRate)
	return  int(carsPerHour) / 60
}

// CalculateCost works out the cost of producing the given number of cars.
func CalculateCost(CarsCount int) uint {
    costPerCar := uint(10000)
    costPerTenCars := uint(95000)
    carsCount := uint(CarsCount)

    costPerCarTotal := carsCount % 10 * costPerCar
    costPerTenCarsTotal := (carsCount / 10) * costPerTenCars

    return costPerTenCarsTotal + costPerCarTotal
}


