var ALLERGENS = {
    "eggs": 1,
    "peanuts": 2,
    "shellfish": 4,
    "strawberries": 8,
    "tomatoes": 16,
    "chocolate": 32,
    "pollen": 64,
    "cats": 128
}

class Allergies {
    construct new(value) {
        _value = value
    }

    list() { ALLERGENS.keys.where { |name| allergicTo(name) }.toList }

    allergicTo(name) {
        var value = ALLERGENS[name]

        if (value) {
            return _value & value != 0
        } else {
            return false
        }
    }
}
