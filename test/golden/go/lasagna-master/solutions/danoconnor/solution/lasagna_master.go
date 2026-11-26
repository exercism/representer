package lasagna

func PreparationTime(layers []string, time int) int {
    if time == 0 {
        time = 2
	}
    return len(layers) * time
}

func Quantities(layers []string) (int, float64) {
    // make sure you have enough sauce and noodles to cook the lasagna of your dreams
    noodleGrams := 0;
    // For each noodle layer in your lasagna, you will need 50 grams of noodles
    for i := 0; i < len(layers); i++ {
        if layers[i] == "noodles" {
            noodleGrams += 50
        }
    }
    // For each sauce layer in your lasagna, you will need 0.2 liters of sauce
    sauceLiters := 0.0;
    // For each noodle layer in your lasagna, you will need 50 grams of noodles
    for i := 0; i < len(layers); i++ {
        if layers[i] == "sauce" {
            sauceLiters += 0.2
        }
    }
    // determine the quantity of noodles and sauce needed to make your meal
    // The result should be returned as two values of noodles as an int and sauce as a float64
    return noodleGrams, sauceLiters
}

func AddSecretIngredient(friendsList []string, myList []string) {
	// The last element in your ingredient list is always "?"
    // replace "?" with the last item from your friends list
    myList[len(myList) - 1] = friendsList[len(friendsList) - 1]
}

func ScaleRecipe(amounts []float64, numberPortions int) []float64 {
    // return a slice of float64 of the amounts needed for the desired number of portions
    scaledQuantities := make([]float64, len(amounts))
    for i := 0; i < len(amounts); i++ {
        scaledQuantities[i] = amounts[i] * (float64(numberPortions) / 2)
    }

    return scaledQuantities
}