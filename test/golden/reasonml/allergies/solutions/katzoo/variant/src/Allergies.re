type allergens =
  | Eggs
  | Peanuts
  | Shellfish
  | Strawberries
  | Tomatoes
  | Chocolate
  | Pollen
  | Cats;

let name_to_allergen =
  fun
  | "eggs" => Some(Eggs)
  | "peanuts" => Some(Peanuts)
  | "shellfish" => Some(Shellfish)
  | "strawberries" => Some(Strawberries)
  | "tomatoes" => Some(Tomatoes)
  | "chocolate" => Some(Chocolate)
  | "pollen" => Some(Pollen)
  | "cats" => Some(Cats)
  | _ => None;

let score_to_allergen =
  fun
  | 1 => Some(Eggs)
  | 2 => Some(Peanuts)
  | 4 => Some(Shellfish)
  | 8 => Some(Strawberries)
  | 16 => Some(Tomatoes)
  | 32 => Some(Chocolate)
  | 64 => Some(Pollen)
  | 128 => Some(Cats)
  | _ => None;

let allergen_to_score =
  fun
  | Eggs => (1, "eggs")
  | Peanuts => (2, "peanuts")
  | Shellfish => (4, "shellfish")
  | Strawberries => (8, "strawberries")
  | Tomatoes => (16, "tomatoes")
  | Chocolate => (32, "chocolate")
  | Pollen => (64, "pollen")
  | Cats => (128, "cats");

let rec score_to_allergy_list =
        (~allergies: list(allergens)=[], ~current_allergen_score: int, score) =>
  if (score <= 0) {
    allergies;
  } else {
    let next_allergen_score = current_allergen_score / 2;
    let next_score = score - current_allergen_score;

    switch (score_to_allergen(current_allergen_score), next_score > 0) {
    | (None, true) =>
      score_to_allergy_list(
        ~allergies,
        ~current_allergen_score=next_allergen_score,
        next_score,
      )
    | (Some(allergen), true) =>
      score_to_allergy_list(
        ~allergies=[allergen, ...allergies],
        ~current_allergen_score=next_allergen_score,
        next_score,
      )
    | (Some(_) | None, false) =>
      score_to_allergy_list(
        ~allergies,
        ~current_allergen_score=next_allergen_score,
        score,
      )
    };
  };

let find_allergies = score => {
  let score_limit = ref(1);
  while (score_limit^ < score) {
    score_limit := score_limit^ * 2;
  };

  score_to_allergy_list(~current_allergen_score=score_limit^, score);
};

let isAllergicTo: (string, int) => bool =
  (allergen_name, allergy_score) => {
    switch (name_to_allergen(allergen_name)) {
    | None => false
    | Some(allergen) =>
      find_allergies(allergy_score)->Belt.List.has(allergen, (==))
    };
  };
let toList: int => list(string) =
  allergy_score =>
    find_allergies(allergy_score)
    |> List.map(allergy => allergen_to_score(allergy) |> snd);
