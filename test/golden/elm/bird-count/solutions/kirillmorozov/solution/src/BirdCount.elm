module BirdCount exposing (busyDays, hasDayWithoutBirds, incrementDayCount, today, total)


today : List Int -> Maybe Int
today counts =
    case counts of
        head :: _ ->
            Just head

        _ ->
            Nothing


incrementDayCount : List Int -> List Int
incrementDayCount counts =
    case counts of
        head :: tail ->
            head + 1 :: tail

        _ ->
            [ 1 ]


hasDayWithoutBirds : List Int -> Bool
hasDayWithoutBirds counts =
    case counts of
        [] ->
            False

        head :: tail ->
            if head == 0 then
                True

            else
                hasDayWithoutBirds tail


total : List Int -> Int
total =
    let
        sum : Int -> List Int -> Int
        sum acc rest =
            case rest of
                [] ->
                    acc

                head :: tail ->
                    sum (acc + head) tail
    in
    sum 0


busyDays : List Int -> Int
busyDays =
    let
        countBusy : Int -> List Int -> Int
        countBusy acc counts =
            case counts of
                [] ->
                    acc

                head :: tail ->
                    if head >= 5 then
                        countBusy (acc + 1) tail

                    else
                        countBusy acc tail
    in
    countBusy 0
