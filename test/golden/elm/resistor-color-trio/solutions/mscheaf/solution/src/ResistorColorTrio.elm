module ResistorColorTrio exposing (Color(..), label)


type Color
    = Black
    | Brown
    | Red
    | Orange
    | Yellow
    | Green
    | Blue
    | Violet
    | Grey
    | White


colorCode : Color -> String
colorCode color =
    case color of
        Black ->
            "0"
         
        Brown ->
            "1"
         
        Red ->
            "2"
        
        Orange ->
            "3"
        
        Yellow ->
            "4"
        
        Green ->
            "5"
        
        Blue ->
            "6"
        
        Violet ->
            "7"
        
        Grey ->
            "8"
        
        White ->
            "9"


value : List Color -> Int
value colors =
    case colors of
        firstColor :: secondColor :: _ ->
            case String.toInt (colorCode firstColor ++ colorCode secondColor) of
                Just fullCode ->
                    fullCode
                Nothing->
                    0
        _ ->
            0    


multiplier :  List Color -> Int
multiplier colors =
    case colors of
        _ :: _ :: thirdColor :: _ ->
            case String.toInt (colorCode thirdColor) of
                Just mult ->
                    mult

                Nothing ->
                    0

        _ ->
            0


label : List Color -> String
label colors =
    let
        base =
            value colors

        mult =
            10 ^ (multiplier colors)

        total =
            base * mult

        ( reducedTotal, prefix ) =
            if total >= 1000000000 then
                ( toFloat total / 1000000000, "giga" )
            else if total >= 1000000 then
                ( toFloat total / 1000000, "mega" )
            else if total >= 1000 then
                ( toFloat total / 1000, "kilo" )
            else
                ( toFloat total, "" )
    in
    String.fromFloat reducedTotal ++ " " ++ prefix ++ "ohms"
    