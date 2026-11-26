module Allergies

open System

type Allergen =
| Eggs = 1
| Peanuts = 2
| Shellfish = 4
| Strawberries = 8
| Tomatoes = 16
| Chocolate = 32
| Pollen = 64
| Cats = 128

let allergicTo (codedAllergies: int) allergen =
  let allergens = enum<Allergen> codedAllergies
  allergens.HasFlag allergen

let list (codedAllergies: int) = 
  let allergens = Enum.GetValues(typeof<Allergen>) |> unbox<Allergen seq>
  allergens 
  |> Seq.where (fun allergen -> allergicTo codedAllergies allergen)
  |> List.ofSeq