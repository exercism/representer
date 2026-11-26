// Package lasagna cooks lasagna for you Garfield
package lasagna

// TODO: define the 'PreparationTime()' function
func PreparationTime(layers []string, prepTime int) int {
    sliceLength := len(layers)
    if prepTime == 0 {
        prepTime = 2
    }
	return int(sliceLength * prepTime)
}

// TODO: define the 'Quantities()' function
func Quantities(layers []string) (int, float64) {
    noodles := 0
    sauce := 0.0
    for _, s := range layers {
        if s == "noodles" {
            noodles++
        } else if s == "sauce" {
        	sauce++
        }
    }
	return int(noodles * 50), float64(sauce * 0.2)
}

// TODO: define the 'AddSecretIngredient()' function
func AddSecretIngredient(friendsList []string, myList []string) {
    count := 0
    for _, s := range friendsList {
        if friendsList[count] == myList[count] {
            count += 1
        } else if friendsList[count] != myList[count] {
        	index := len(myList) - 1
            myList[index] = s
        }
    }
}

// TODO: define the 'ScaleRecipe()' function
func ScaleRecipe(portionQuantities []float64, wantedPortions int) []float64 {
	if len(portionQuantities) == 0 {
		return []float64{}
	}
	var newQuantities []float64
	for _, quantity := range portionQuantities {
		newQuantities = append(newQuantities, quantity / 2 * float64(wantedPortions))
	}
	return newQuantities
}
