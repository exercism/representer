module Anagram

open System

let findAnagrams (sources: list<string>) (target: string) : list<string> =
    let cleanse (str : string) : string = str.ToLower()
    let sortString = cleanse >> Seq.sort >> String.Concat
    sources
    |> List.filter (fun x -> cleanse x <> cleanse target)
    |> List.filter (fun (x:string) -> sortString x = sortString target)