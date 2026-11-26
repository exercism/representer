module Pangram

let isPangram (input: string) = 
    "abcdefghijklmnopqrstuvwxyz" 
        |> Seq.toList  
        |> Seq.forall (fun x -> input.ToLower().Contains(x))
