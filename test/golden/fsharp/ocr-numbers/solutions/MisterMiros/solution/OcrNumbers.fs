module OcrNumbers

let digitWidth = 3
let digitHeight = 4

let chunkStringBySize (size: int) (value: string) = 
    value
    |> Seq.chunkBySize size
    |> Seq.map (System.String)
    |> List.ofSeq

let convertSingle input = 
    match input with
        | [" _ "; "| |"; "|_|"; "   "] -> "0"
        | ["   "; "  |"; "  |"; "   "] -> "1"
        | [" _ "; " _|"; "|_ "; "   "] -> "2"
        | [" _ "; " _|"; " _|"; "   "] -> "3"
        | ["   "; "|_|"; "  |"; "   "] -> "4"
        | [" _ "; "|_ "; " _|"; "   "] -> "5"
        | [" _ "; "|_ "; "|_|"; "   "] -> "6"
        | [" _ "; "  |"; "  |"; "   "] -> "7"
        | [" _ "; "|_|"; "|_|"; "   "] -> "8"
        | [" _ "; "|_|"; " _|"; "   "] -> "9"
        | _ -> "?"

let convertLine input =
    input 
    |> List.map (chunkStringBySize digitWidth)
    |> List.transpose
    |> List.map (convertSingle)
    |> String.concat ""

let convert (input: string list) = 
    if (List.length input) % digitHeight <> 0
        || String.length input.[0] % digitWidth <> 0 
        || (input.[1..] |> List.exists (fun i -> (String.length i) <> (String.length input.[0])))
    then None
    else
    input
    |> List.chunkBySize digitHeight
    |> List.map (convertLine)
    |> String.concat ","
    |> Some