module ListOps

let length list =
    let mutable count = 0
    [ for i in list do count <- count + 1 ] |> ignore
    count

let map f list =
    [ for i in list -> i |> f ]

let rec foldl folder state list =
    match list with
    | [] -> state
    | head::tail -> foldl folder (folder state head) tail

let reverse list =
    list
    |> foldl (fun acc x ->
        x::acc
    ) []

let foldr folder state list =
    let rec f folder1 state1 list1 =
        match list1 with
        | [] -> state1
        | head::tail -> f folder1 (folder1 state1 head) tail
    f folder state (list |> reverse)

let filter f list =
    list
    |> map (fun x -> if f x then Some x else None)
    |> foldr (fun acc y ->
        match y with
        | None -> acc
        | Some c -> c::acc
    ) []

let concat xs =
    xs
    |> foldr (fun acc x ->
        x
        |> foldr (fun acc2 y ->
            y::acc2
        ) acc
    ) []
    

let append xs ys =
    concat [xs; ys]