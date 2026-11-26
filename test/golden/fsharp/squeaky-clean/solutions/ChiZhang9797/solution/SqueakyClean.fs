module SqueakyClean

open System

let transform (c: char) : string =
    match c with
    | '-' -> "_"
    | ' '
    | '\t' -> ""
    | l when Char.IsUpper l -> $"-{Char.ToLower l}"
    | d when Char.IsDigit d -> ""
    | g when int g > 944 && int g < 970 -> "?"
    | _ -> string c

let clean (identifier: string) : string =
    identifier |> Seq.map transform |> String.concat ""
