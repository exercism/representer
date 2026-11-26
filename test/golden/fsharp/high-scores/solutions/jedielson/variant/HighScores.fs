module HighScores

let scores (values: int list): int list = 
    values

let latest (values: int list): int = 
    values |> Seq.last

let personalBest (values: int list): int = 
    values |> Seq.max

let personalTopThree (values: int list): int list = 
    values 
    |> List.sortDescending
    |> List.truncate 4