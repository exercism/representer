module Satellite

type Tree =
    | Empty
    | Node of value: string * left: Tree * right: Tree

let treeFromTraversals inorder preorder  =
    let rec loop preorder inorder =
        match preorder with
        | [] -> Empty
        | x::xs -> 
            let index = inorder |> List.findIndex ((=) x)
            let leftInorder = inorder[0..index-1]
            let leftPreorder =
                xs |> List.filter (fun n -> leftInorder |> List.contains n)
            let rightInorder = inorder[index+1..]
            let rightPreorder =
                xs |> List.filter (fun n -> rightInorder |> List.contains n)
            Node (x, 
                loop leftPreorder leftInorder,
                loop rightPreorder rightInorder
            )
    if List.length inorder <> List.length preorder then
        Error "traversals must have the same length"
    elif inorder <> List.distinct inorder || preorder <> List.distinct preorder then
        Error "traversals must contain unique items"
    elif List.sort inorder <> List.sort preorder then
        Error "traversals must have the same elements"
    else
        Ok (loop preorder inorder)
            

