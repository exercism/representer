module Isogram

open System

let isIsogram (str: string) =
    str
    |> Seq.filter Char.IsLetter
    |> Seq.countBy Char.ToLower
    |> Seq.forall (fun (_, count) -> count = 1)
