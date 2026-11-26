open Base

type bst =
  | Empty
  | Node of int * bst * bst

let empty = Empty

let value n = match n with
  | Empty -> Error "Empty"
  | Node (v, _, _) -> Ok v

let left n = match n with
  | Empty -> Error "Empty"
  | Node (_, left, _) -> Ok left

let right n = match n with
  | Empty -> Error "Empty"
  | Node (_, _, right) -> Ok right

let rec insert v tree = match tree with
  | Empty -> Node (v, Empty, Empty)
  | Node (v2, left, right) -> if v <= v2 then Node (v2, (insert v left), right)
                          else Node (v2, left, (insert v right))

let rec to_list tree = match tree with
  | Empty -> []
  | Node (v, left, right) -> (to_list left) @ [v] @ (to_list right)
