module SimpleLinkedList

type Node =
  { value: int; next: LinkedList }
and LinkedList =
  | Empty
  | Node of Node

let nil = Empty

let create x n =
  Node { value=x; next=n }

let isNil x = x = Empty

let next x =
  match x with
  | Node n -> n.next
  | Empty -> Empty

let datum x =
  match x with
  | Node n -> n.value
  | Empty -> 0

let fold f init l =
  let rec aux acc l =
    match l with
    | Empty -> acc
    | Node n -> aux (f acc n.value) n.next

  aux init l

let foldr f init l =
  let rec aux acc l =
    match l with
    | Empty -> acc
    | Node n -> f n.value (aux acc n.next)

  aux init l

let toList x =
  foldr (fun v acc -> v :: acc) [] x

let fromList xs =
  List.foldBack (fun v acc -> create v acc) xs Empty

let reverse x =
  fold (fun acc v -> create v acc) Empty x
