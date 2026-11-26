module RotationalCipher

open System
let alphabetLength = int 'z' - int 'a' - 1

let rotate shiftKey (text : string) =

    let shiftChar c =
        if Char.IsLetter(c) && Char.ToLower(c) >= 'a' && Char.ToLower(c) <= 'z'
        then
            let baseLetter = if Char.IsLower(c) then 'a' else 'A'
            (int c - int baseLetter + shiftKey) % alphabetLength + int baseLetter |> char
        else
            c
    
    text |> Seq.map shiftChar |> Array.ofSeq |> String