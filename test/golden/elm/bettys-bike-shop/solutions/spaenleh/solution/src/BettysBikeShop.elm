module BettysBikeShop exposing (poundsToString, penceToPounds)
import String exposing (fromFloat)

penceToPounds : Int -> Float
penceToPounds pence =
    toFloat pence / 100

poundsToString : Float -> String
poundsToString pounds =
    "£" ++ fromFloat pounds
