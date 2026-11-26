package lasagna
const (
	defautlPreparationTimePerLayer = 2
	noodleQtyPerLayer              = 50
	sauceQtyPerLayer               = 0.2
	defaultServingInRecipe         = 2
)

func PreparationTime(layers []string, preparationTimePerLayer int) int {
	if preparationTimePerLayer <= 0 {
		preparationTimePerLayer = defautlPreparationTimePerLayer
	}
	return len(layers) * preparationTimePerLayer
}

func Quantities(layers []string) (int, float64) {
	noodleLayers := 0
	sauceLayers := 0
	for _, l := range layers {
		switch l {
		case "noodles":
			noodleLayers++
		case "sauce":
			sauceLayers++
		}
	}
	return noodleLayers * noodleQtyPerLayer, float64(sauceLayers) * sauceQtyPerLayer
}

func AddSecretIngredient(friendsList, myList []string) {
	myList[len(myList)-1] = friendsList[len(friendsList)-1]
}
// ScaleRecipe gives the amounts needed for the desired number of portions
func ScaleRecipe(amounts []float64, quantities int) []float64 {
	var scaledAmounts []float64
	for _, recipeQty := range amounts {
		scaledAmounts = append(scaledAmounts, recipeQty/defaultServingInRecipe*float64(quantities))
	}
	return scaledAmounts
}