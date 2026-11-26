module Dominoes

let rec makeChain (result: list<int * int>) (input: list<int * int>) =
    match result, input with
    | [], [] -> Some []
    | [], [ a, b ] when a = b -> Some [ (a, b) ]
    | [], [ a, b ] when a <> b -> None
    | [], head :: tail -> makeChain [ head ] tail
    | result, [ a, b ] ->
        let first = result |> List.head |> fst
        let last = result |> List.last |> snd

        match a, b with
        | a, b when last = a && first = b -> Some(result @ [ a, b ])
        | a, b when last = b && first = a -> Some(result @ [ b, a ])
        | _ -> None
    | result, input ->
        let last = result |> List.last |> snd

        let candidates =
            input
            |> List.filter (fun (a, b) -> last = a || last = b)

        candidates
        |> List.tryPick (fun candidate ->
            let newDomino =
                match candidate with
                | a, _ when last = a -> candidate
                | _ -> (snd candidate, fst candidate)

            let newResult = result @ [ newDomino ]
            let nonCandidates = input |> List.filter (fun d -> d <> candidate)
            let sameCandidates = input |> List.filter (fun d -> d = candidate)

            let newInput =
                sameCandidates
                |> List.skip 1
                |> List.append nonCandidates

            makeChain newResult newInput)

let canChain (input: list<int * int>) =
    match makeChain [] input with
    | Some _ -> true
    | _ -> false
