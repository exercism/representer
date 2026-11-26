module Allergies

type Allergen =
    | Eggs
    | Peanuts
    | Shellfish
    | Strawberries
    | Tomatoes
    | Chocolate
    | Pollen
    | Cats

let Allergens =
    [ Allergen.Eggs
      Allergen.Peanuts
      Allergen.Shellfish
      Allergen.Strawberries
      Allergen.Tomatoes
      Allergen.Chocolate
      Allergen.Pollen
      Allergen.Cats ]

let allergicTo (codedAllergies: int) (allergen: Allergen) =
    let rec allergicTo' (codedAllergies: int) (allergen: Allergen) (allergens: Allergen list) =
        match allergens with
        | [] -> false
        | x :: (xss: Allergen list) when x = allergen -> (codedAllergies % 2) = 1
        | x :: xss -> allergicTo' (codedAllergies / 2) allergen xss

    allergicTo' codedAllergies allergen Allergens

let list (codedAllergies: int) : Allergen list =
    let rec list' (coded: int) (allergies: Allergen list) (output: Allergen list) : Allergen list =
        let bit = (coded % 2) = 1

        match allergies, bit with
        | [], _ -> output
        | a :: restOfAllergies, false -> list' (coded / 2) restOfAllergies output
        | a :: restOfAllergies, true -> list' (coded / 2) restOfAllergies (a :: output)

    list' codedAllergies Allergens [] |> List.rev
