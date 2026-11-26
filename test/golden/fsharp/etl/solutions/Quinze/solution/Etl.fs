module Etl
open System

let transform (scoresWithLetters: Map<int, char list>): Map<char, int> = 
    Map.fold 
        (fun state (key: int) (value: char list) -> List.fold (fun s v -> Map.add (Char.ToLower(v)) key s) state value) 
        Map.empty<char, int>
        scoresWithLetters