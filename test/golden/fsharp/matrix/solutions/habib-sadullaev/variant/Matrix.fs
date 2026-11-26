module Matrix

let split (sep: char) (s: string) = 
    s.Split sep |> List.ofArray 

let parse =
    split '\n' >> List.map (split ' ' >> List.map int)
    
let row index matrix =
    matrix |> parse |> List.item (index - 1)

let column index matrix =
    matrix |> parse |> List.map (List.item (index + 1))