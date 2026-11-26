module Series

open System

let slices (str:string) length = 

    match str.Length with
    | l when l < length || length < 1 || l = 0 -> None
    | _ ->  Some (str 
                  |> Seq.toList 
                  |> Seq.windowed length 
                  |> Seq.map (fun c -> (c |> Seq.fold (fun acc ch -> acc + (string)ch) ""))
                  |> List.ofSeq)