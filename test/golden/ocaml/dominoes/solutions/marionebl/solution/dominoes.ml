open Base

type dominoe = (int * int)

let matches ((_, ab): dominoe) (i: int) ((ba, bb): dominoe): (int * dominoe) option =
  if Int.(ab = ba) then Some (i, (ba, bb))
  else if Int.(ab = bb) then Some (i, (bb, ba))
  else None

let first (l: dominoe list): int option = l |> List.hd |> Option.map ~f:fst
let last (l: dominoe list): int option = l |> List.last |> Option.map ~f:snd

let is_valid (l: dominoe list) (ll: dominoe list): bool =
  Int.(List.length l = List.length ll) && 
  Option.both (first ll) (last ll) |> 
  Option.value_map ~default:false ~f:(fun (f, l) -> Int.(f = l))

let except c i = List.filteri c ~f:(fun ii _ -> i <> ii)

let rec build (path: dominoe list) (candidates: dominoe list): dominoe list list =
  match (candidates, path) with
  | ([], _) -> [path]
  | (_, p::_) -> 
    List.filter_mapi candidates ~f:(matches p)
    |> List.concat_map ~f:(fun (i, d) -> build (d :: path) (except candidates i))
  | _ -> failwith "unreachable"

let chain (l: dominoe list): dominoe list option =
  match l with
  | [] -> Some []
  | [(a, b)] when Int.(a = b) -> Some [(a, b)]
  | _ -> List.concat_mapi l ~f:(fun i d -> 
    build [d] (except l i))
    |> List.map ~f:List.rev
    |> List.find ~f:(is_valid l)