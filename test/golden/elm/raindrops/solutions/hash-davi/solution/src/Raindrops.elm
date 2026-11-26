module Raindrops exposing (raindrops)


raindrops : Int -> String
raindrops number =
    let
        pling =
            if modBy 3 number == 0 then
                "Pling"
            else
                ""

        plang =
            if modBy 5 number == 0 then
                "Plang"
            else
                ""

        plong =
            if modBy 7 number == 0 then
                "Plong"
            else
                ""

        plingPlangPlong =
            pling ++ plang ++ plong
    in
        if String.isEmpty plingPlangPlong then
            String.fromInt number
        else
            plingPlangPlong
