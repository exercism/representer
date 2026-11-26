module Hamming

let distance (strand1: string) (strand2: string): int option =
    match (strand1.Length, strand2.Length) with
    | (l1, l2) when l1 <> l2 -> None
    | _ -> Seq.map2 (fun a b -> a = b) strand1 strand2
           |> Seq.filter ((=) true)
           |> Seq.length
           |> Some