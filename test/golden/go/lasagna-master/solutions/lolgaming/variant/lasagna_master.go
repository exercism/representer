package lasagnamaster
import "slices"

// TODO: define the 'PreparationTime()' function
func PreparationTime(layers []string, avgPrepTimePerLayer int) (prepTime int) {
    // If uninitialized, set avgPrepTimePerLayer to 2.
    if avgPrepTimePerLayer != 0 {
        avgPrepTimePerLayer = 2
    }
    return len(layers) * avgPrepTimePerLayer
}
// TODO: define the 'Quantities()' function
func Quantities(layers []string) (amtNoodles int, amtSauce float64) {
    for i := 0; i < len(layers); i++ {
        if layers[i] == "noodles" {
            amtNoodles += 50
        } else if layers[i] == "sauce" {
        	amtSauce += 0.2
    	}
    }
    return
}

// TODO: define the 'AddSecretIngredient()' function
func AddSecretIngredient(friendIngredients []string, ownIngredients []string) {
    ownIngredients[len(ownIngredients) - 1] = friendIngredients[len(friendIngredients) - 1]
}
// TODO: define the 'ScaleRecipe()' function
func ScaleRecipe(amounts []float64, portions int) (scaledAmounts []float64) {
    newAmounts := slices.Clone(amounts)
    for i, v := range amounts {
        newAmounts[i] = v * (float64(portions) / 2)
    }
    return newAmounts
}
// Your first steps could be to read through the tasks, and create
// these functions with their correct parameter lists and return types.
// The function body only needs to contain `panic("")`.
//
// This will make the tests compile, but they will fail.
// You can then implement the function logic one by one and see
// an increasing number of tests passing as you implement more
// functionality.
