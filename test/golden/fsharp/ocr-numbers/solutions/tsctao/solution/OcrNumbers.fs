module OcrNumbers

let map4 f a b c =
    List.map2 (<|) (List.map3 f a b c)

let validateInput (rows: string list) =
    rows.Length % 4 = 0 && rows |> List.forall (fun row -> row.Length % 3 = 0)

let toGrids (rows: string list list) =
    map4 (fun r1 r2 r3 r4 -> [r1; r2; r3; r4])
    <| rows.[0]
    <| rows.[1]
    <| rows.[2]
    <| rows.[3]

let recognize grid =
    match grid with
    | [ " _ ";
        "| |";
        "|_|";
        "   " ] -> "0"
    | [ "   ";
        "  |";
        "  |";
        "   " ] -> "1"
    | [ " _ ";
        " _|";
        "|_ ";
        "   " ] -> "2"
    | [ " _ ";
        " _|";
        " _|";
        "   " ] -> "3"
    | [ "   ";
        "|_|";
        "  |";
        "   " ] -> "4"
    | [ " _ ";
        "|_ ";
        " _|";
        "   " ] -> "5"
    | [ " _ ";
        "|_ ";
        "|_|";
        "   " ] -> "6"
    | [ " _ ";
        "  |";
        "  |";
        "   " ] -> "7"
    | [ " _ ";
        "|_|";
        "|_|";
        "   " ] -> "8"
    | [ " _ ";
        "|_|";
        " _|";
        "   " ] -> "9"
    | _ -> "?"

let convert input =
    if validateInput input then
        input
        |> List.chunkBySize 4
        |> List.map
            (List.map
                (Seq.chunkBySize 3 >> Seq.map System.String >> Seq.toList)
                >> toGrids
                >> List.map recognize
                >> List.fold (+) ""
            )
        |> List.reduce (fun line1 line2 -> line1 + "," + line2)
        |> Some
    else None