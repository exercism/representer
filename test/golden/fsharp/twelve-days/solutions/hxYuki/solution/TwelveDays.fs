module TwelveDays

let recite start stop =
    let serial d =
        match d with
        | 1 -> "first"
        | 2 -> "second"
        | 3 -> "third"
        | 4 -> "fourth"
        | 5 -> "fifth"
        | 6 -> "sixth"
        | 7 -> "seventh"
        | 8 -> "eighth"
        | 9 -> "ninth"
        | 10 -> "tenth"
        | 11 -> "eleventh"
        | 12 -> "twelfth"
        | _ -> failwith "invalid day"

    let items d =
        match d with
        | 1 -> "a Partridge in a Pear Tree"
        | 2 -> "two Turtle Doves"
        | 3 -> "three French Hens"
        | 4 -> "four Calling Birds"
        | 5 -> "five Gold Rings"
        | 6 -> "six Geese-a-Laying"
        | 7 -> "seven Swans-a-Swimming"
        | 8 -> "eight Maids-a-Milking"
        | 9 -> "nine Ladies Dancing"
        | 10 -> "ten Lords-a-Leaping"
        | 11 -> "eleven Pipers Piping"
        | 12 -> "twelve Drummers Drumming"
        | _ -> failwith "invalid day"

    let rec givings cur start stop acc = 
        let con cur (acc: string list) = 
            if acc.Length = 0 then
                items cur
            elif cur = 2 then
                items cur + ", and " + acc.Head
            else
                items cur + ", " + acc.Head
            
        match (cur ,start, stop) with
        | (cur, min, max) when cur > max -> acc |> List.rev
        | (cur, min, max) when cur <= min -> givings (cur + 1) min max [con cur acc]
        | (cur, min, max) -> givings (cur + 1) min max ((con cur acc) :: acc)

    givings 1 start stop [] |> List.mapi (fun i x -> $"On the {serial (i + start)} day of Christmas my true love gave to me: {x}.")
