module AllYourBase exposing (rebase)

toIntermediate : Int -> List Int -> Int
toIntermediate base digits =
    digits
    |> List.foldl (\n acc -> acc * base + n) 0

toBase : Int -> Int -> List Int
toBase base number =
    let
        loop n acc =
            if n >= base then
                loop (n // base) ((modBy base n)::acc)
            else
                n::acc
    in
        loop number []

rebase : Int -> List Int -> Int -> Maybe (List Int)
rebase inBase digits outBase =
    let
        nonZero = List.any (\x -> x > 0) digits
        validBases = inBase > 1 && outBase > 1
        validDigits = List.all (\n -> n < inBase && n > 0) digits
        valid = validBases && validDigits && nonZero
    in
        if not valid then
            Nothing
        else
            digits
            |> toIntermediate inBase
            |> toBase outBase
            |> Just
