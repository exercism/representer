package lasagna


// you can declare consts in a block
// type inference, but you can also state the type
// camelcase is prefered in golang
const (
	preparationTimePerLayerDefault = 2
	gramsOfNoodlesPerLayer = 50
	sauceLitresPerLayer               = 0.2
	defaultServingInRecipe         = 2
)


// 1. Estimate the preparation time, based on the number of layers
func PreparationTime(layers []string, preparationTimePerLayer int) int {
	if preparationTimePerLayer <= 0 {
		// defautlPreparationTimePerLayer couldve been a
		// default value of the function argument in another
		// language, but not in go
		preparationTimePerLayer = preparationTimePerLayerDefault
	}
	return len(layers) * preparationTimePerLayer
}

// 2. Compute the amounts of noodles and sauce needed
func Quantities(layers []string) (int, float64) {
	// := is assignment with type inference, but only for local variables
	noodleLayers := 0
	sauceLayers := 0
	for _, l := range layers {
		switch l {
		case "noodles":
			//we got ++ like in C
			noodleLayers++
		case "sauce":
			sauceLayers++
		}
	}
	return noodleLayers * gramsOfNoodlesPerLayer, float64(sauceLayers) * sauceLitresPerLayer
}

// 3. Add the secret ingredient
func AddSecretIngredient(friendsList, myList []string) {
	myList[len(myList)-1] = friendsList[len(friendsList)-1]
}

// 4. Scale the recipe
func ScaleRecipe(amounts []float64, quantities int) []float64 {
	var scaledAmounts []float64
	// just copy the list, scale each amount,
	// the for - range construct works like a foreach, or somewhat like a map
	for _, recipeQty := range amounts {
		scaledAmounts = append(scaledAmounts, recipeQty/defaultServingInRecipe*float64(quantities))
	}
	return scaledAmounts
}



