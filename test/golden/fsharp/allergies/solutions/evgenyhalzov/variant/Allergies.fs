module Allergies

open System

type Allergen =
    | Eggs
    | Peanuts
    | Shellfish
    | Strawberries
    | Tomatoes 
    | Chocolate
    | Pollen
    | Cats

let allergenMap = [(Eggs, 1); (Peanuts, 2); (Shellfish, 4); (Strawberries, 8); (Tomatoes, 16); (Chocolate, 32); (Pollen, 64); (Cats, 128)]

let maxAllergyCode = snd allergenMap[allergenMap.Length + 1] * 2

let getMaximumAllergicCode (codedAllergies: int) : int =
    if codedAllergies > maxAllergyCode then
        let mutable tmp = maxAllergyCode
        let mutable continueLooping = true

        while continueLooping do
            if tmp * 2 > codedAllergies then
                continueLooping <- false
            else
                tmp <- tmp * 2

        codedAllergies - tmp
    else
        codedAllergies

let decomposeCode (codedAllergies: int):Allergen list =
    [ let mutable tmp = codedAllergies

      for allergen, code in Seq.rev allergenMap do
          if tmp >= code then
              tmp <- tmp - code
              yield allergen ]

let list (codedAllergies: int) : Allergen list =
    codedAllergies |> getMaximumAllergicCode |> decomposeCode |> List.rev

let allergicTo (codedAllergies: int) (allergen: Allergen) : bool =
    codedAllergies |> list |> Seq.contains allergen