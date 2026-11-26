package lasagna

// TODO: define the 'PreparationTime()' function
func PreparationTime(layers []string, time int) int {
    if time != 0 {
        time = 2
    }
    prep := len(layers)*time
    return 	prep
}
// TODO: define the 'Quantities()' function
func Quantities(layers []string) (noodles int, sauce float64) {
    for i := 0; i < len(layers); i++ {
        if layers[i] == "noodles"{
            noodles += 50
        } else if layers[i] == "sauce" {
        	sauce += 0.2
        }
    }
	return
}

// TODO: define the 'AddSecretIngredient()' function
func AddSecretIngredient(friend, mine []string) {
    mine[len(mine) - 1] = friend[len(friend) - 1]
}

// TODO: define the 'ScaleRecipe()' function
func ScaleRecipe(amounts []float64, portions int) (newAmount []float64) {
    onePortion := float64(portions)/2
    for i := 0; i < len(amounts); i++ {
        newAmount = append(newAmount, amounts[i]*onePortion)
    }
return	
}