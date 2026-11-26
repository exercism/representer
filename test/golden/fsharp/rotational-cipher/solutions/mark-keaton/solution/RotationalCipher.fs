module RotationalCipher

open System

let lowercaseAlphabet = seq { 'a'..'z' } |> Seq.append (seq { 'a' .. 'z' }) |> Array.ofSeq
let uppercaseAlphabet = seq { 'A'..'Z' } |> Seq.append (seq { 'A' .. 'Z' }) |> Array.ofSeq


let rotateChar (rotation: int) (c: char) =
    let uppercaseOffset = 65 - rotation
    let lowercaseOffset = 97 - rotation
    
    match (Char.IsUpper c, Char.IsLower c) with
    | (true, false) -> int c |> (-) uppercaseOffset |> abs |> uppercaseAlphabet.GetValue
    | (false, true) -> int c |> (-) lowercaseOffset |> abs |> lowercaseAlphabet.GetValue
    | _ -> c

let rotate (shiftKey: int) (text: string) =
    let rotation = shiftKey % 26
    Seq.map (rotateChar rotation) text
    |> String.Concat
    