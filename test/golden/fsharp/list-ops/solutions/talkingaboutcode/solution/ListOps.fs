module ListOps

let rec foldl (folder: 'a -> 'b -> 'a) (state:'a) =
    function
    | [] -> state
    | h::t -> foldl folder (folder state h) t

let length list = foldl (fun acc _ -> acc + 1) 0 list
 
let reverse list = foldl (fun acc x -> x::acc) [] list

let foldr folder state = reverse >> foldl (fun acc x -> folder x acc) state
 
let map f = foldr (fun x acc -> f x::acc) []

let filter pred = foldr (fun x acc -> if pred x then x::acc else acc) []

let append xs ys = foldr (fun x acc -> x::acc) ys xs

let concat xs = foldl append [] xs