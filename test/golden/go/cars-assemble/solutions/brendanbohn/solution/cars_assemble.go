package cars

const carsPerBatch int = 10

// CalculateWorkingCarsPerHour calculates how many working cars are
// produced by the assembly line every hour.
func CalculateWorkingCarsPerHour(productionRate int, successRate float64) float64 {
    var percentageSuccessRate = successRate * .01
	return float64(productionRate) * percentageSuccessRate
}

// CalculateWorkingCarsPerMinute calculates how many working cars are
// produced by the assembly line every minute.
func CalculateWorkingCarsPerMinute(productionRate int, successRate float64) int {
	return int(CalculateWorkingCarsPerHour(productionRate, successRate) / 60)
}

// CalculateCost works out the cost of producing the given number of cars.
func CalculateCost(carsCount int) uint {
	var groupsOfCarsCount = carsCount / carsPerBatch
    var individualCarCount = carsCount % carsPerBatch

    var groupsOfCarsCost = uint(groupsOfCarsCount * 95000)
    var individualCarCost = uint(individualCarCount * 10000)

    return groupsOfCarsCost + individualCarCost;
}
