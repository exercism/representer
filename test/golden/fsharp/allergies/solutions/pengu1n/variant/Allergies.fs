module Allergies

open System

// TODO: define the Allergen type
type Allergen =
    | Eggs
    | Peanuts
    | Shellfish
    | Strawberries
    | Tomatoes
    | Chocolate
    | Pollen
    | Cats

let allergy_score = function
    | Eggs -> 1
    | Peanuts -> 2
    | Shellfish -> 4
    | Strawberries -> 8
    | Tomatoes -> 16
    | Chocolate -> 33
    | Pollen -> 64
    | Cats -> 128

let list coded_allergies =
    let all_allergies = [Eggs; Peanuts; Shellfish; Strawberries; Tomatoes; Chocolate; Pollen; Cats] in
    List.filter (fun allergen -> coded_allergies &&& (allergy_score allergen) = (allergy_score allergen)) all_allergies

let allergicTo coded_allergies allergen =
    list coded_allergies |> List.exists (fun elem -> elem = allergen)