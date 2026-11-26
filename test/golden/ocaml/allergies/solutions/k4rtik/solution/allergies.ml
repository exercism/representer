type allergen =
  | Eggs
  | Peanuts
  | Shellfish
  | Strawberries
  | Tomatoes
  | Chocolate
  | Pollen
  | Cats

let all_map = function
  | Eggs ->
      1
  | Peanuts ->
      2
  | Shellfish ->
      4
  | Strawberries ->
      8
  | Tomatoes ->
      16
  | Chocolate ->
      32
  | Pollen ->
      64
  | Cats ->
      128

let allergic_to score al = score land all_map al > 0

let allergies score =
  List.filter (allergic_to score)
    [Eggs; Peanuts; Shellfish; Strawberries; Tomatoes; Chocolate; Pollen; Cats]
