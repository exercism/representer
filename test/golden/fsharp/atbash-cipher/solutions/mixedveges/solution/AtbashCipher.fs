module AtbashCipher

open System

let convert =
    function
    | c when Char.IsDigit c -> c
    | c -> int 'z' - int c + int 'a' |> char

let transform (str: string) =
    str.ToLower()
    |> Seq.filter Char.IsLetterOrDigit
    |> Seq.map convert
    |> String.Concat

let encode (str: string) =
    str
    |> transform
    |> Seq.chunkBySize 5
    |> Seq.map String
    |> String.concat " "

let decode = transform
