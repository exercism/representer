module Etl

let transform (scoresWithLetters: Map<int, char list>): Map<char, int> = 
    scoresWithLetters
    |> Map.toList
    |> List.collect (fun (number, charlist) -> charlist |> List.map (fun x -> System.Char.ToLower x, number))
    |> Map.ofList