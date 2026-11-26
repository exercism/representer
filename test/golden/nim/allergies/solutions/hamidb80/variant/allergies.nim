type
  Allergen* = enum
    Eggs, Peanuts, Shellfish, Strawberries, Tomatoes, Chocolate, Pollen, Cats

proc isAllergicTo*(score: int, allergen: Allergen): bool =
  (1 shl allergen.ord or score) != 0

proc allergies*(score: int): set[Allergen] =
  for a in Allergen:
    if score.isAllergicTo a:
      result.incl a
