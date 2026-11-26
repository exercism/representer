package cars

// CalculateWorkingCarsPerHour calculates how many working cars are
// produced by the assembly line every hour.
func CalculateWorkingCarsPerHour(productionRate int, successRate float64) float64 {
	return float64(productionRate)*successRate*0.01;
}

// CalculateWorkingCarsPerMinute calculates how many working cars are
// produced by the assembly line every minute.
func CalculateWorkingCarsPerMinute(productionRate int, successRate float64) int {
	return int(float64(productionRate)*successRate*0.01/60);
}

// CalculateCost works out the cost of producing the given number of cars.
func CalculateCost(carsCount int) uint {
	groupsOf10 := carsCount/ 10
    individualCars := carsCount % 10

    // Calculate the cost for producing groups of 10 cars and individual cars separately
    costGroupsOf10 := groupsOf10 * 95000 // Each group of 10 costs $95,000
    costIndividualCars := individualCars * 10000 // Each individual car costs $10,000

    // Calculate the total cost
    totalCost := costGroupsOf10 + costIndividualCars

    return uint(totalCost)
    
}
