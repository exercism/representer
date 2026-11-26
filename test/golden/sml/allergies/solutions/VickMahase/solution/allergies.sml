datatype allergen 
  = Eggs 
  | Peanuts 
  | Shellfish 
  | Strawberries 
  | Tomatoes 
  | Chocolate 
  | Pollen 
  | Cats

(* Map of allergens to their corresponding scores *)
val allergenScores = [
  (Eggs, 1),
  (Peanuts, 2),
  (Shellfish, 4),
  (Strawberries, 8),
  (Tomatoes, 16),
  (Chocolate, 32),
  (Pollen, 64),
  (Cats, 128)
]

(* Check if a person is allergic to a specific allergen *)
fun allergicTo (score: int) (allergen: allergen): bool =
  let 
    val (_, allergenScore) = valOf (List.find (fn (a, _) => a = allergen) allergenScores)
  in
    (score div allergenScore mod 2) = 1
  end

(* Get the list of allergens a person is allergic to *)
fun allergies (score: int): allergen list =
  let 
    fun filterAllergies (allAllergens, acc) =
      case allAllergens of
        [] => rev acc
      | (allergen, allergenScore)::rest =>
          if (score div allergenScore mod 2) = 1
          then filterAllergies(rest, allergen::acc)
          else filterAllergies(rest, acc)
  in
    filterAllergies(allergenScores, [])
  end