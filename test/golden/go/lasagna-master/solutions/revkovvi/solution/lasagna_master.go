package lasagna

// TODO: define the 'PreparationTime()' function
func PreparationTime(layers []string, timePerLeer int) int {
	if timePerLeer == 0 {
		timePerLeer = 2
	}
	return timePerLeer * len(layers)
}

// TODO: define the 'Quantities()' function
func Quantities(layers []string) (int, float64) {
	const noodlesPerLeer int = 50
	const saucePerLeer float64 = 0.2
	noodlesQuantity := 0
	sauceQuantity := 0.0
	for _, v := range layers {
		if v == "noodles" {
			noodlesQuantity += noodlesPerLeer
		} else if v == "sauce" {
			sauceQuantity += saucePerLeer
		}
	}
	return noodlesQuantity, sauceQuantity
}

// TODO: define the 'AddSecretIngredient()' function
func AddSecretIngredient(friendsList, myList []string) {
	myList[len(myList)-1] = friendsList[len(friendsList)-1]
}

// TODO: define the 'ScaleRecipe()' function
func ScaleRecipe(quantities []float64, num int) []float64 {
	result := append([]float64{}, quantities...)
	for i, v := range result {
		result[i] = v * float64(num) / 2.0
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
