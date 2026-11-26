module AllYourBase

let toBase10 digits inputBase =
    let sum, _ = Seq.foldBack (fun digit (sum, index) ->
            let summand = digit * (pown inputBase index)
            (sum + summand, index + 1)) digits (0, 0)
    sum

let fromBase10 num outputBase =
    let rec convert num state =
        match num with
        | 0 -> state
        | n -> convert (n / outputBase) ((n % outputBase) :: state)
    let result = convert num List.empty
    if result = [] then [0]
    else result

let rebase digits inputBase outputBase =
    match digits, inputBase, outputBase with
    | _, i, o when i < 2 || o < 2 -> None
    | d, _, _ when List.exists (fun n -> n < 0) d -> None
    | d, i, _ when List.exists (fun n -> n >= i) d -> None
    | d, i, o -> Some (fromBase10 (toBase10 d i) o)