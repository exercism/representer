module Anagram

open System

let toLower: string -> string = Seq.map Char.ToLower >> String.Concat 
let sortString = Seq.map Char.ToLower >> Seq.sort >> String.Concat
let sortedEqButNotSelf (target: string) (other: string) =
    (toLower target <> toLower other) && ((sortString target) = (sortString other))

let findAnagrams (sources: string list) (target: string) =
    List.filter (sortedEqButNotSelf target) sources
    
    
