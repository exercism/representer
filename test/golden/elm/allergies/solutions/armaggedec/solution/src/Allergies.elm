module Allergies exposing (Allergy(..), isAllergicTo, toList)

import Bitwise exposing(..)

type Allergy
    = Eggs
    | Peanuts
    | Shellfish
    | Strawberries
    | Tomatoes
    | Chocolate
    | Pollen
    | Cats


isAllergicTo : Allergy -> Int -> Bool
isAllergicTo allergy score =
    List.member allergy (toList score)


toList : Int -> List Allergy
toList score =
    let 
        allergies = [ ( Eggs, 1 ), ( Peanuts, 2 ), ( Shellfish, 4 ), ( Strawberries, 8 ), ( Tomatoes, 16 ), ( Chocolate, 32 ), ( Pollen, 64 ), ( Cats, 128 ) ] 
    in 
    List.map Tuple.first (List.filter (\x -> and score (Tuple.second x) == Tuple.second x) allergies)
