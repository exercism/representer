module LargestSeriesProduct

let largestProduct (input: string) (seriesLength: int) : int option = 
    if seriesLength < 0 then None
    elif seriesLength = 0 then Some(1)
    elif seriesLength > (String.length input) then None
    else
        try
            [for c in input do c]
            |> List.windowed seriesLength 
            |> List.map (List.map (string))   
            |> List.map (List.map (int)) 
            |> List.map (List.fold (fun acc el -> acc * el) 1)
            |> List.max 
            |> Some
        with 
            ex -> None