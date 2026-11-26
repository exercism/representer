open Base

type bst = Node of (bst * bst * int) | Nil

let empty = Nil

let value tree = 
    match tree with
  | Node (_, _, v) -> Ok v
  | Nil -> Error "nil"

let left tree = 
    match tree with 
  | Node (l, _, _) -> Ok l
  | Nil -> Error "nil"

let right tree = 
    match tree with 
  | Node (_, r, _) -> Ok r
  | Nil -> Error "nil"

let rec insert v tree = 
    match tree with
  | Node (l, r, node_v) -> 
    if v <= node_v then Node (insert v l, r, node_v) else Node (l, insert v r, node_v)
  | Nil -> Node (Nil, Nil, v)

let rec to_list tree =
    match tree with 
  | Node(l, r, v) -> 
      let l_list = to_list l in
      let r_list = to_list r in
       l_list @ (v::r_list)
  | Nil -> []

