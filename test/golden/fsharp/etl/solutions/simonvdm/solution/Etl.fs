module Etl

let transform (scoresWithLetters: Map<int, char list>): Map<char, int> = 
    scoresWithLetters
    |> Map.toList
    |> List.collect (fun (score,letters) -> letters |> List.map (fun c -> System.Char.ToLower c,score)) 
    |> Map.ofList