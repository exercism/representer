package lasagna

// TODO: define the 'PreparationTime()' function
func PreparationTime(layers []string, time int) int {
    if time == 0 {
        return len(layers) * 2
    }
	return len(layers) * time
}
// TODO: define the 'Quantities()' function
func Quantities(layers []string) (noodles int, sauce float64) {
	for _, value := range layers {
		if value == "noodles" {
			noodles += 50
		} else if value == "sauce" {
			sauce += 0.2
		}
	}
	return
}

// TODO: define the 'AddSecretIngredient()' function
func AddSecretIngredient(friendsIngredient []string, myIngredients []string) {
    myIngredients[len(myIngredients)-1] = friendsIngredient[len(friendsIngredient)-1]
    
}
// TODO: define the 'ScaleRecipe()' function
func ScaleRecipe(inBook []float64, want int) []float64 {
	var res = make([]float64, len(inBook))
	copy(res, inBook)
	coin := float64(want) / 2.0
	for index, value := range res {
		res[index] = value * float64(coin)
	}
	return res

}
// Your first steps could be to read through the tasks, and create
// these functions with their correct parameter lists and return types.
// The function body only needs to contain `panic("")`.
// 
// This will make the tests compile, but they will fail.
// You can then implement the function logic one by one and see
// an increasing number of tests passing as you implement more 
// functionality.
