module ReverseString
open System

let rec reverseIter (input:'a list) (collector:'a list) : 'a list =
    match input with
    | [] -> collector
    | head::tail -> reverseIter tail (head::collector)

// Typical recursive solution
// Alternatives would be to use Seq.rev or Array.fold(Back)
let reverse (input: string): string = 
    let chList = Seq.toList input
    reverseIter chList List.Empty
        |> Array.ofList
        |> String
    