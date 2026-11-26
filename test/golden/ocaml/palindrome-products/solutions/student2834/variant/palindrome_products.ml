type palindrome_products = { value : int option; factors : (int * int) list }

let range a b = Seq.ints a |> Seq.take (b - a - 1)

let is_pal s =
  let rec aux left right =
    if left > right then true
    else if s.[left] <> s.[right] then false
    else aux (left + 1) (right - 1)
  in
  aux 0 (String.length s - 1);;

let rec last l =
  match l with
  | [] -> None
  | [x] -> Some x
  | _ :: t -> last t

let first l =
  match l with
    | [] -> None
    | x :: _ -> Some x

let get_pals min max =
  Seq.flat_map
      (fun x -> Seq.map (fun y -> (x * y, x, y)) (range x max))
      (range min max)
    |> Seq.filter (fun (xy, _, _) -> xy |> string_of_int |> is_pal)
    |> List.of_seq |> List.sort compare
    |> List.fold_left
         (fun acc (xy, x, y) ->
           match acc with
           | (ab, factors) :: t when xy = ab -> (xy, (x, y) :: factors) :: t
           | _ -> (xy, [ (x, y) ]) :: acc)
         []

let smallest ~min ~max =
  if min > max then Error "min must be <= max"
  else
    get_pals min max
    |> last
    |> (function
        | None -> Ok {value=None; factors=[]}
        | Some (v, fs) -> Ok {value=Some v; factors=List.rev fs})

let largest ~min ~max =
  if min > max then Error "min must be <= max"
  else
    get_pals min max
    |> first
    |> (function
        | None -> Ok {value=None; factors=[]}
        | Some (v, fs) -> Ok {value=Some v; factors=List.rev fs})
