module Allergies

open System

type Allergen = 
    |Eggs=1
    |Peanuts=2
    |Shellfish=4
    |Strawberries=8
    |Tomatoes=16
    |Chocolate=32
    |Pollen=64
    |Cats=128

let findAllergens(allergyScore:int) =
    Enum.GetValues<Allergen>()|>Array.map(int)|>Array.filter(fun code->code&&&allergyScore<>0)|>Array.map(enum<Allergen>)

let allergicTo codedAllergies allergen = 
    findAllergens codedAllergies|>Set.ofArray|>Set.contains allergen

let list codedAllergies = codedAllergies|>findAllergens|>List.ofArray