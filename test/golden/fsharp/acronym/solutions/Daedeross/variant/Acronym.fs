module Acronym

open System
open System.Text.RegularExpressions

let re = Regex "([A-Za-z]+'?[A-Za-z]*)"

let abbreviate (phrase: string) =
    phrase
    |> re.Matches
    |> Seq.map (fun m -> m.Value.[1] |> Char.ToUpper)
    |> Array.ofSeq
    |> String