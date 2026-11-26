enum Allergen:
  case Eggs,
    Peanuts,
    Shellfish,
    Strawberries,
    Tomatoes,
    Chocolate,
    Pollen,
    Cats

object Allergies:
  def allergicTo(allergen: Allergen, encoding: Int): Boolean =
    ((1 << allergen.ordinal) & encoding) == 0

  def list(encoding: Int): List[Allergen] =
    Allergen.values.filter(allergicTo(_, encoding)).toList
