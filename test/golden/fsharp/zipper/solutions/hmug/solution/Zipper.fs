module Zipper

type Tree<'a> = Tree of value: 'a * left: Tree<'a> option * right: Tree<'a> option

type Direction<'a> =
    | Left of value: 'a * right: Tree<'a> option
    | Right of value: 'a * left: Tree<'a> option

type Zipper<'a> = Zipper of tree: Tree<'a> * path: Direction<'a> list

let tree value left right = Tree(value, left, right)

let fromTree tree = Zipper(tree, [])

let up = function
    | Zipper (_, []) -> None
    | Zipper (left, Left (value, right) :: directions) ->
        Zipper(tree value (Some left) right, directions)
        |> Some
    | Zipper (right, Right (value, left) :: directions) ->
        Zipper(tree value left (Some right), directions)
        |> Some
        
let rec toTree (Zipper(tree, _) as zipper) =
    zipper
    |> up
    |> Option.map toTree
    |> Option.defaultValue tree

let value (Zipper (Tree (v, _, _), _)) = v

let down dir directions head =
    head
    |> Option.map (fun tree -> Zipper(tree, dir :: directions))

let left (Zipper (Tree (value, left, right), directions) as zipper) =
    down (Left(value, right)) directions left

let right (Zipper (Tree (value, left, right), directions) as zipper) =
    down (Right(value, left)) directions right

let setValue newValue (Zipper (Tree (_, left, right), directions)) =
    Zipper(tree newValue left right, directions)

let setLeft newLeft (Zipper (Tree (value, _, right), directions)) =
    Zipper(tree value newLeft right, directions)

let setRight newRight (Zipper (Tree (value, left, _), directions)) =
    Zipper(tree value left newRight, directions)