module RailFenceCipher

let next max position increment =
    match max, position, increment with
    | 0, _, _ -> (0, 1)
    | _, 0, _ -> (1, 1)
    | n, p, _ when p = n -> (p - 1, -1)
    | _, p, i -> (p + i, i)

let rec toMap chars position increment (map: Map<int, list<char>>) =
    match chars with
    | [] -> map
    | a :: rest ->
        let max = map |> Map.maxKeyValue |> fst
        let value' = map.[position] @ [ a ]
        let map' = map.Add(position, value')
        let (position', increment') = next max position increment
        toMap rest position' increment' map'

let rec toChars (map: Map<int, list<char>>) position increment chars =
    match map.[position] with
    | [] -> chars
    | a :: rest ->
        let max = map |> Map.maxKeyValue |> fst
        let map' = map.Add(position, rest)
        let result' = chars @ [ a ]
        let (position', increment') = next max position increment
        toChars map' position' increment' result'

let toString (chars: list<char>) =
    chars |> Array.ofList |> System.String.Concat

let initMap rails =
    seq { 0 .. rails - 1 }
    |> Seq.map (fun i -> (i, []))
    |> Map.ofSeq

let encode rails (message: string) =
    let map = initMap rails
    let chars = Seq.toList message

    (toMap chars 0 1 map).Values
    |> Seq.reduce List.append
    |> toString


let decode rails message =
    let map = initMap rails
    let chars = Seq.toList message
    let map' = toMap chars 0 1 map

    let subbed =
        ((Map<int, list<char>> [], chars), map')
        ||> Map.fold (fun (map'', chars) n s ->
            (map''.Add(n, (chars |> List.take (List.length s))), chars |> List.skip (List.length s)))
        |> fst

    toChars subbed 0 1 [] |> toString
