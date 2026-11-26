module Allergies exposing (Allergy(..), isAllergicTo, toList)
import Bitwise

type Allergy
    = Eggs
    | Peanuts
    | Shellfish
    | Strawberries
    | Tomatoes
    | Chocolate
    | Pollen
    | Cats

allAllergens =
    [ Eggs
    , Peanuts
    , Shellfish
    , Strawberries
    , Tomatoes
    , Chocolate
    , Pollen
    , Cats
    ]

allergenScore : Allergy -> Int
allergenScore allergen =
    case allergen of
        Eggs ->
            1
        Peanuts ->
            2
        Shellfish ->
            4
        Strawberries ->
            8
        Tomatoes ->
            16
        Chocolate ->
            32
        Pollen ->
            64
        Cats ->
            128

isAllergicTo : Allergy -> Int -> Bool
isAllergicTo allergy score =
    Bitwise.and (allergenScore allergy) score > 0

toList : Int -> List Allergy
toList score =
    List.filter (\a -> isAllergicTo a score) allAllergens