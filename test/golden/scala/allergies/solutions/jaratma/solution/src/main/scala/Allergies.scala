import Allergen.Allergen

object Allergen extends Enumeration {
    type Allergen = Value
    val Eggs = Value(1)
    val Peanuts = Value(2)
    val Shellfish = Value(4)
    val Strawberries = Value(8)
    val Tomatoes = Value(16)
    val Chocolate = Value(32)
    val Pollen = Value(64)
    val Cats = Value(128)
}

object Allergies {
    def allergicTo(al: Allergen, level: Int): Boolean = (al.id & level) == al.id

    def list(level: Int): List[Allergen] = Allergen.values.filter(al => (al.id & level) == al.id).toList
}