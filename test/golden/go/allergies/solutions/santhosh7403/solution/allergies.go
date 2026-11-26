package allergies

func Allergies(allergies uint) []string {
	allergens := []string{}
	for i := 0; i < 8; i++ {
		if allergies&(1<<i) != 0 {
			switch i {
			case 0:
				allergens = append(allergens, "eggs")
			case 1:
				allergens = append(allergens, "peanuts")
			case 2:
				allergens = append(allergens, "shellfish")
			case 3:
				allergens = append(allergens, "strawberries")
			case 4:
				allergens = append(allergens, "tomatoes")
			case 5:
				allergens = append(allergens, "chocolate")
			case 6:
				allergens = append(allergens, "pollen")
			case 7:
				allergens = append(allergens, "cats")

			}
		}
	}
	return allergens
}

func AllergicTo(allergies uint, allergen string) bool {
	for _, i := range Allergies(allergies) {
		if i == allergen {
			return true
		}
	}
	return false
}
