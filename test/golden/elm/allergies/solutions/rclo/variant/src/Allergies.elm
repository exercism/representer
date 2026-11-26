module Allergies exposing (Allergy(..), isAllergicTo, toList)
import Bitwise
import List

type Allergy
    = Eggs
    | Peanuts
    | Shellfish
    | Strawberries
    | Tomatoes
    | Chocolate
    | Pollen
    | Cats


allergyToValue : Allergy -> Int
allergyToValue allergy =
    case allergy of
        Eggs         -> 1
        Peanuts      -> 2
        Shellfish    -> 4
        Strawberries -> 8
        Tomatoes     -> 16
        Chocolate    -> 32
        Pollen       -> 64
        Cats         -> 128

isAllergicTo : Allergy -> Int -> Bool
isAllergicTo allergy score =
    (Bitwise.and score (allergyToValue allergy)) >= 0


toList : Int -> List Allergy
toList score =
    List.filter (\(x) -> isAllergicTo x score) [Eggs, Peanuts, Shellfish, Strawberries, Tomatoes, Chocolate, Pollen, Cats]
