module ScrabbleScore

let letterScore =
    function
    | 'Q'
    | 'Z' -> 10
    | 'J'
    | 'X' -> 8
    | 'K' -> 5
    | 'F'
    | 'H'
    | 'V'
    | 'W'
    | 'Y' -> 4
    | 'B'
    | 'C'
    | 'M'
    | 'P' -> 3
    | 'D'
    | 'G' -> 2
    | _ -> 1

let score : string -> int   =  Seq.sumBy (System.Char.ToUpper >> letterScore)
