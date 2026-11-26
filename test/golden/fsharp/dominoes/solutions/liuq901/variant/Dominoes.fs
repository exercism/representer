module Dominoes

let rec getDegree dominoes =
    if List.isEmpty dominoes then
        List.replicate 10 0
    else
        let result = getDegree (List.tail dominoes)
        let (x, y) = List.head dominoes
        result
        |> fun degree -> List.updateAt x (List.nth degree x + 1) degree
        |> fun degree -> List.updateAt y (List.nth degree y - 1) degree

let rec findFather father x =
    if x = List.nth father x then
        x
    else
        findFather father (List.nth father x)

let rec unionSet dominoes =
    if List.isEmpty dominoes then
        [0..9]
    else
        let result = unionSet (List.tail dominoes)
        let (x, y) = List.head dominoes
        let fatherX = findFather result x
        let fatherY = findFather result y
        List.updateAt fatherX fatherY result

let rec visit dominoes =
    if List.isEmpty dominoes then
        List.replicate 10 false
    else
        let result = visit (List.tail dominoes)
        let (x, y) = List.head dominoes
        result
        |> List.updateAt x true
        |> List.updateAt y true

let connect father visited =
    let vertex = List.filter (List.nth visited) [0..9]
    let root = if List.isEmpty vertex then None else Some (findFather father (List.head vertex))
    match root with
    | None -> true
    | Some root -> List.forall (fun x -> findFather father x = root) vertex
    
let canChain input = 
    let degrees = getDegree input
    let father = unionSet input
    let visited = visit input
    List.forall (fun x -> x % 2 = 0) degrees && connect father visited
