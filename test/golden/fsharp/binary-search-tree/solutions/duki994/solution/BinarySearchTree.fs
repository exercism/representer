module BinarySearchTree

open System

type Tree<'T> =
    | Leaf
    | Node of value: 'T * left: Tree<'T> * right: Tree<'T>

let left node =
    match node with
    | Leaf -> None
    | Node (_, left, _) when left <> Leaf -> Some(left)
    | _ -> None

let right node =
    match node with
    | Leaf -> None
    | Node (_, _, right) when right <> Leaf -> Some(right)
    | _ -> None

let data node =
    match node with
    | Leaf -> Int32.MinValue // can't get value of leaf node! possibly use failwith?
    | Node (value, _, _) -> value

let rec insertIntoBST item tree =
    match tree with
    | Leaf -> Node(item, Leaf, Leaf)
    | Node (value, left, right) when item <= value -> Node(value, insertIntoBST item left, right)
    | Node (value, left, right) when item > value -> Node(value, left, insertIntoBST item right)
    | _ -> tree

let create items =
    items
    |> List.fold (fun tree x -> insertIntoBST x tree) Leaf


let sortedData node =
    let rec toList =
        function
        | Node (value, left, right) ->
            // In-Order traversal + yield + yield! expressions
            [ yield! toList left
              yield value
              yield! toList right ]
        | Leaf -> []

    node |> toList
