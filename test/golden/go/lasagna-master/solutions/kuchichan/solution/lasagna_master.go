package lasagna

// TODO: define the 'PreparationTime()' function
func PreparationTime(layers []string, number int) int {
    if number == 0 {
        return len(layers) * 2
    }
    return len(layers) * number
}
// TODO: define the 'Quantities()' function
func Quantities(layers []string) (int, float64) {
    var noodlesAmount int
    var sauceAmount float64
    for _, value := range(layers) {
        switch value {
        case "noodles":
        	noodlesAmount += 50
        case "sauce":
        	sauceAmount += 0.2
        }
    }
	return noodlesAmount, sauceAmount
}
// TODO: define the 'AddSecretIngredient()' function
func AddSecretIngredient(friendsList []string, myList []string) {
    myList[len(myList) - 1] = friendsList[len(friendsList) - 1]
}
// TODO: define the 'ScaleRecipe()' function
func ScaleRecipe(quantities []float64, numOfPortions int) []float64 {
    result := make([]float64, len(quantities))
    for i, v := range(quantities) {
        result[i] = v * float64(numOfPortions) / 2.0
    }
	return result
}
// Your first steps could be to read through the tasks, and create
// these functions with their correct parameter lists and return types.
// The function body only needs to contain `panic("")`.
// 
// This will make the tests compile, but they will fail.
// You can then implement the function logic one by one and see
// an increasing number of tests passing as you implement more 
// functionality.
