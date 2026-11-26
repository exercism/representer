package lasagna

// TODO: define the 'PreparationTime()' function
func PreparationTime(layers []string, avgPreparationTime int) int {
    if avgPreparationTime == 0 {
        return len(layers) * 2
    }
	return len(layers) * avgPreparationTime
}

const NoodlesAmountInGrams = 50
const SauceAmountInLiters = 0.2

// TODO: define the 'Quantities()' function
func Quantities(layers []string) (noodlesQuantityInGrams int, sauceQuantityInLiters float64) {
    for _, layer := range layers {
        if layer == "noodles" {
            noodlesQuantityInGrams += NoodlesAmountInGrams
        } else if layer == "sauce" {
        	sauceQuantityInLiters += SauceAmountInLiters
        }
    }
	return
}

// TODO: define the 'AddSecretIngredient()' function
func AddSecretIngredient(friendIngredients, myIngredients []string) {
    myIngredients[len(myIngredients) - 1] = friendIngredients[len(friendIngredients) - 1]
}

// TODO: define the 'ScaleRecipe()' function
func ScaleRecipe(amountsForTwoPortions []float64, portions int) (scaledRecipes []float64) {
    scaleMultiplier := float64(portions) / 2.0
    for _, amount := range amountsForTwoPortions {
        scaledRecipes = append(scaledRecipes, amount * scaleMultiplier)
    }
	return
}

// Your first steps could be to read through the tasks, and create
// these functions with their correct parameter lists and return types.
// The function body only needs to contain `panic("")`.
// 
// This will make the tests compile, but they will fail.
// You can then implement the function logic one by one and see
// an increasing number of tests passing as you implement more 
// functionality.
