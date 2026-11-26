module BinarySearch

let find (input: int[]) (value: int): int option =
    let rec binarySearchForIndex input value startIndex endIndex =
        let length = endIndex - startIndex
        match length, startIndex + length / 2 with
        | 0, _ -> None
        | 1, i ->
            input
            |> Array.tryItem i
            |> Option.filter ((=) value)
            |> Option.map (fun _ -> i)
        | _, i ->
            match input |> Array.tryItem i with
            | Some o when o < value -> binarySearchForIndex input value i endIndex
            | Some o when o > value -> binarySearchForIndex input value startIndex i
            | Some o -> Some i
            | None -> None

    Array.length input
    |> binarySearchForIndex input value 0