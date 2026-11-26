module Isogram
open System

let rec iterIsogram chArray collector =
    match chArray with
    | [] -> true
    | [c] -> Set.contains c collector |> not
    | head::tail -> 
        if Set.contains head collector then
            false
        else
            Set.add head collector
            |> iterIsogram tail 

let isIsogram (str: String): bool = 
    let chArray = 
        Seq.toList str
        |> List.filter (fun c -> Char.IsLetter c)
        |> List.map (fun c -> Char.ToLower c)

    iterIsogram chArray Set.empty
    