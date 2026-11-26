type
  Allergen* = enum
    Eggs, Peanuts, Shellfish, Strawberries, Tomatoes, Chocolate, Pollen, Cats

proc allergies*(score: int): set[Allergen] =
  cast[typeof(result)](score)

proc isAllergicTo*(score: int, allergen: Allergen): bool =
  allergen in allergies(score)
