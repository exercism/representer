package allergies

var allergens = map[string]uint{
	"eggs":        1,
	"peanuts":     2,
	"shellfish":   4,
	"strawberries": 8,
	"tomatoes":    16,
	"chocolate":   32,
	"pollen":      64,
	"cats":        128,
}

// Allergies returns a list of all allergens the person is allergic to
func Allergies(allergies uint) []string {
	var result []string
	for allergen, score := range allergens {
		if allergies&score != 0 {
			result = append(result, allergen)
		}
	}
	return result
}

// AllergicTo checks if the person is allergic to a specific allergen
func AllergicTo(allergies uint, allergen string) bool {
	score, exists := allergens[allergen]
	if !exists {
		return false
	}
	return allergies&score != 0
}

