module RotationalCipher

open System

let rotate shiftKey (text:string) =
    match shiftKey with 
    | 0 | 26 -> text
    | _ -> String.map (fun c -> 
        if Char.IsLetter c then
            let lastLetter = if Char.IsUpper c then 'Z' else 'z'
            let shifted = int c + shiftKey
            if int lastLetter >= shifted then
                char shifted
            else 
                shifted - 26 |> char
        else
            c) text