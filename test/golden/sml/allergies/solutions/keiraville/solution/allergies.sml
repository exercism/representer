datatype allergen = Eggs
                  | Peanuts
                  | Shellfish
                  | Strawberries
                  | Tomatoes
                  | Chocolate
                  | Pollen
                  | Cats

fun allergenValue (a: allergen): int =
  case a of
      Eggs => 1
    | Peanuts => 2
    | Shellfish => 4
    | Strawberries => 8
    | Tomatoes => 16
    | Chocolate => 32
    | Pollen => 64
    | Cats => 128

fun allergicTo (score: int) (a: allergen): bool =
  Word.fromInt score = Word.orb (Word.fromInt score, Word.fromInt (allergenValue a))

fun allergies (score: int): allergen list =
  List.filter (allergicTo score) [Eggs, Peanuts, Shellfish, Strawberries, Tomatoes, Chocolate, Pollen, Cats]
