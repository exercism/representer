module Etl

open System

let transform (scoresWithLetters: Map<int, char list>) : Map<char, int> =
    scoresWithLetters
    |> Map.toList
    |> List.collect (fun (s, ls) -> ls |> List.map (fun l -> Char.ToLower l, s))
    |> Map.ofList
