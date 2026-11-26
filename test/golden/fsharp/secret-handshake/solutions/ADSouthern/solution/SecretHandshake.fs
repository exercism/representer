module SecretHandshake

let commands (number: int) =
    let loop digit startPoint=
        match startPoint with
        | 0 when digit = 1 -> "wink"
        | 1 when digit = 1 -> "double blink"
        | 2 when digit = 1 -> "close your eyes"
        | 3 when digit = 1 -> "jump"
        | 4 when digit = 1 -> "reverse"
        | _ -> ""
    
    let actionSeq =
        System.Convert.ToString(number, 2)
        |> Seq.rev
        |> Seq.mapi (fun i ch -> loop (int ch - int '0') i)
        |> Seq.filter (fun s -> s <> "")

    if actionSeq |> Seq.contains "reverse" then
        actionSeq |> Seq.rev |> Seq.filter (fun s -> s <> "reverse") |> Seq.toList
    else 
        actionSeq |> Seq.toList