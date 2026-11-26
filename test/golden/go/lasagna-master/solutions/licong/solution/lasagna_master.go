package lasagna

// TODO: define the 'PreparationTime()' function
func PreparationTime(layers []string, minutePerLayer int) int {
    if (minutePerLayer == 0) {
        return 2 * len(layers)
    } else {
    	return minutePerLayer * len(layers)
    }
}

// TODO: define the 'Quantities()' function
func Quantities(layers []string) (noodlesQuantities int, sauceQuantities float64) {
    for i:= 0; i < len(layers); i++ {
        if (layers[i] == "noodles") {
            noodlesQuantities += 50
        } else if (layers[i] == "sauce") {
        	sauceQuantities +=0.2
        }
    }
    return
}

// TODO: define the 'AddSecretIngredient()' function
func AddSecretIngredient(friendsList []string, myList []string) {
    endIndexOfFriendsList := len(friendsList)
    endIndexOfMyList := len(myList)
    if (endIndexOfFriendsList == 0 || endIndexOfMyList == 0) {
        return
    }
	myList[endIndexOfMyList - 1] = friendsList[endIndexOfFriendsList - 1]
}

// TODO: define the 'ScaleRecipe()' function
func ScaleRecipe(quantities []float64, numberOfPortion int) []float64 {
    // slice := make([]T, length, capacity)
    lenOfQuantities := len(quantities)
    if lenOfQuantities == 0 {
        return []float64{}
    }
    scaledQuantities := make([]float64, lenOfQuantities, lenOfQuantities)
    for i := 0; i < lenOfQuantities; i++ {
        // 错误示例：scaledQuantities[i] = quantities[i] * float64(numberOfPortion / 2)
        scaledQuantities[i] = quantities[i] * float64(numberOfPortion) / 2
    }

    return scaledQuantities
}

// Your first steps could be to read through the tasks, and create
// these functions with their correct parameter lists and return types.
// The function body only needs to contain `panic("")`.
// 
// This will make the tests compile, but they will fail.
// You can then implement the function logic one by one and see
// an increasing number of tests passing as you implement more 
// functionality.
