module Etl

open System

let transform (scoresWithLetters: Map<int, char list>): Map<char, int> = 
    scoresWithLetters
    |> Map.toList
    |> List.collect (fun (n,cs) -> cs |> List.map (fun c -> Char.ToLower c, n))
    |> Map.ofList