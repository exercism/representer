module BettysBikeShop exposing (penceToPounds, poundsToString)

penceToPounds : Int -> Float
penceToPounds pence = toFloat pence / 100.00 
 

poundsToString : Float -> String
poundsToString pounds = "£" ++ String.fromFloat pounds