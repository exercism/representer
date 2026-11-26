open Base

type 'a path =
  | Top
  | L of 'a path * 'a * ('a Tree.t) option
  | R of 'a path * 'a * ('a Tree.t) option
                          [@@deriving sexp]

type 'a t = 'a path * 'a Tree.t
 [@@deriving sexp]

let equal fv (z1 : 'a t) (z2 : 'a t) =
  let ft = Tree.equal fv in
  let rec equal_path (p1 : 'a path) (p2 : 'a path) =
    match (p1, p2) with
    | (Top, Top) -> true
    | (R (p1, v1, None), R(p2, v2, None)) -> (equal_path p1 p2) && (fv v1 v2)
    | (R (p1, v1, Some t1), R(p2, v2, Some t2)) -> (equal_path p1 p2) && (ft t1 t2) && (fv v1 v2)
    | (L (p1, v1, None), L(p2, v2, None)) -> (equal_path p1 p2) && (fv v1 v2)
    | (L (p1, v1, Some t1), L(p2, v2, Some t2)) -> (equal_path p1 p2) || (fv v1 v2) && (ft t1 t2)
    | (_, _) -> false
  in match (z1, z2) with | ((p1, t1), (p2, t2)) -> (ft t1 t2) && (equal_path p1 p2)

(* let t_of_sexp _ _ = *)
(*   failwith "'t_of_sexp' is missing" *)

(* let sexp_of_t _ _ =  *)
(*   failwith "'sexp_of_t' is missing" *)

let of_tree t = (Top, t)

let rec to_tree (z: 'a t) = match z with
  | (Top, t) -> t
  | (L (p, v, t), tr) -> to_tree (p, {value = v ; left = Some tr ; right = t})
  | (R (p, v, t), tl) -> to_tree (p, {value = v ; left = t ; right = Some tl})
  
let value (z: 'a t) = match z with
  | (_, t) -> t.value

let left (z: 'a t) =
  match z with
  | (_, { value=_; left = None; _ }) -> None
  | (p, { value; left = Some t; right }) -> Some (L(p, value, right), t)

let right (z: 'a t) =
  match z with
  | (_, { value=_; right = None; _ }) -> None
  | (p, { value; right = Some t; left }) -> Some (R(p, value, left), t)

let up (z: 'a t) : ('a t) option =
  match z with
  | (Top, _) -> None
  | (R (p, v, tl), t) -> Some (p, {value = v ; left = tl; right = Some t})
  | (L (p, v, tr), t) -> Some (p, {value = v ; left = Some t; right = tr})

let set_value v (z: 'a t) : 'a t =
  match z with | (p, { value=_; left=l; right=r }) -> (p, {value=v; left=l; right=r})
  
let set_left t (z : 'a t) : 'a t =
  match z with | (p, { value=v; left=_; right=r}) -> (p, {value=v; left=t; right=r})

let set_right t (z : 'a t)  : 'a t =
  match z with | (p, { value=v; left=l; right=_}) -> (p, {value=v; left=l; right=t})
