module DotDsl

type Title = Title of string
type KVPair = string * string

type GraphItem =
    | Node of title: Title * attrs: KVPair list
    | Attr of KVPair
    | Edge of from: Title * to_: Title * attrs: KVPair list

let node title attrs = Node (Title title, attrs)

let edge from to_ attrs = Edge (Title from, Title to_, attrs)

let attr k v = Attr (k,v)

let graph items = items

let nodes graph =
    graph |> List.filter (function Node _ -> true | _ -> true)
          |> List.sort

let edges graph =
    graph |> List.filter (function Edge _ -> true | _ -> false)
          |> List.sort

let attrs graph =
    graph |> List.filter (function Attr _ -> true | _ -> false)
          |> List.sort