module Etl

let transform (scoresWithLetters: Map<int, char list>): Map<char, int> =
    scoresWithLetters
    |> Map.toList
    |> List.collect (fun (k, v) -> v |> List.map (fun c -> System.Char.ToLower c, k))
    |> Map.ofList
