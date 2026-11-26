module Etl

open System

let transform (scoresWithLetters: Map<int, char list>): Map<char, int> =
    scoresWithLetters
    |> Seq.collect(fun kv ->
        Seq.map (fun c -> (Char.ToUpper(c), kv.Key)) kv.Value)
    |> Map.ofSeq