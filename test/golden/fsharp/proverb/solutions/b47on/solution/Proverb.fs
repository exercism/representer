module Proverb

let recite (input: string list) : string list =

    input
    |> List.tryHead
    |> Option.map (fun x -> [ $"And all for the want of a {x}." ])
    |> Option.defaultValue []
    |> List.append (
        input
        |> List.pairwise
        |> List.collect (fun (a, b) -> [ $"For want of a {a} the {b} was lost." ])
    )
