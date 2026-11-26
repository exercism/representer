module ListOps

let rec foldl folder state list =
    match list with
    | [] -> state
    | x :: xs -> foldl folder (folder state x) xs

let rec foldr folder state list = 
    match list with
    | [] -> state
    | x :: xs -> folder (foldr folder state xs) x

let length list = 
    foldl (fun acc _ -> acc + 1) 0 list

let reverse list =
    foldl (fun acc x -> x :: acc) [] list

let map f list = 
    foldl (fun acc x -> f x :: acc) [] list
    |> reverse

let filter f list = 
    foldl (fun acc x -> if f x then x :: acc else acc) [] list
    |> reverse

let append xs ys =
    reverse xs
    |> foldl (fun acc x -> x :: acc) ys

let concat xs = 
    foldl append [] xs
