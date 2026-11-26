module Isogram

open System
open System.Text.RegularExpressions

let isIsogram (str: string) =
    let culled = Regex.Replace (str.ToLower(), @"[^a-z]", String.Empty)

    culled
    |> Seq.distinct
    |> Seq.length
    |> (=) (String.length culled)
