module OcrNumbers

let zero = [ " _ "; "| |"; "|_|"; "   " ]
let one = [ "   "; "  |"; "  |"; "   " ]
let two = [ " _ "; " _|"; "|_ "; "   " ]
let three = [ " _ "; " _|"; " _|"; "   " ]
let four = [ "   "; "|_|"; "  |"; "   " ]
let five = [ " _ "; "|_ "; " _|"; "   " ]
let six = [ " _ "; "|_ "; "|_|"; "   " ]
let seven = [ " _ "; "  |"; "  |"; "   " ]
let eight = [ " _ "; "|_|"; "|_|"; "   " ]
let nine = [ " _ "; "|_|"; " _|"; "   " ]
let digits = [ zero; one; two; three; four; five; six; seven; eight; nine ]

let digit input =
    match digits |> List.tryFindIndex (fun i -> input = i) with
    | Some v -> v.ToString()
    | _ -> "?"
let convertLine (input: string list) =
    input
    |> List.map (fun i -> i |> Seq.chunkBySize 3 |> Seq.map (fun s -> new string(s)) |> Seq.toList)
    |> List.transpose
    |> List.map digit
    |> String.concat ""

let convert (input: string list) = 
    match input with
        | i when i.Length % 4 <> 0 -> None
        | i when i |> List.forall (fun x -> x.Length % 3 <> 0) -> None
        | _ -> input 
            |> List.chunkBySize 4
            |> List.map convertLine        
            |> String.concat ","
            |> Some