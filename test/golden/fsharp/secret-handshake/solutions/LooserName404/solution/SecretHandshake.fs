module SecretHandshake

open System

let charListToString (l: seq<char>) = l |> Seq.map string |> String.concat ""

let toBinString (number: int) = Convert.ToString(number, 2)
let fromBinCharList (l: seq<char>) = Convert.ToInt32((l |> charListToString), 2)

let rec commands (number: int) =
    let bin = number |> toBinString

    match bin |> Seq.toList with
    | '1'::xs when xs.Length = 4 -> commands (xs |> fromBinCharList) |> List.rev
    | '1'::xs when xs.Length = 3 -> commands (xs |> fromBinCharList) @ ["jump"]
    | '1'::xs when xs.Length = 2 -> commands (xs |> fromBinCharList) @ ["close your eyes"]
    | '1'::xs when xs.Length = 1 -> commands (xs |> fromBinCharList) @ ["double blink"]
    | ['1'] -> ["wink"]
    | _ -> []