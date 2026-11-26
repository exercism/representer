package lasagna

// Custom function
func countLayers(layers []string, word string) int {
	count := 0
	for _, layer := range layers {
		if layer == word {
			count++
		}
	}
	return count
}

// TODO: define the 'PreparationTime()' function
func PreparationTime(layers []string, time int) int {
	if time == 0 {
		time = 2
	}
	return len(layers) * time
}

// TODO: define the 'Quantities()' function
func Quantities(layers []string) (int, float64) {
	return countLayers(layers, "noodles") * 50, float64(countLayers(layers, "sauce")) * 0.2
}

// TODO: define the 'AddSecretIngredient()' function
func AddSecretIngredient(friendsList, myList []string) {
	myList[len(myList)-1] = friendsList[len(friendsList)-1]
}

// TODO: define the 'ScaleRecipe()' function
func ScaleRecipe(quantities []float64, count int) []float64 {
	var list []float64
	for i := 0; i < len(quantities); i++ {
		list = append(list, quantities[i]/2*float64(count))
	}
	return list
}

// Your first steps could be to read through the tasks, and create
// these functions with their correct parameter lists and return types.
// The function body only needs to contain `panic("")`.
//
// This will make the tests compile, but they will fail.
// You can then implement the function logic one by one and see
// an increasing number of tests passing as you implement more
// functionality.
