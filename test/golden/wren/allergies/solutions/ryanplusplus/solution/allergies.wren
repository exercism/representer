var ALLERGENS = [
  "eggs",
  "peanuts",
  "shellfish",
  "strawberries",
  "tomatoes",
  "chocolate",
  "pollen",
  "cats"
]

class Allergies {
  construct new(score) {
    _score = score
  }

  list() { ALLERGENS.where { |allergen| allergicTo(allergen) }.toList }

  allergicTo(name) { (1 << ALLERGENS.indexOf(name)) & _score > 0 }
}
