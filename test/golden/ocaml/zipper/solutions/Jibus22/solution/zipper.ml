open Base

(**
   Solution totally inspired by toddmath one bc I didn't understood a sh*t at
   first glance (and also the 2nd one).

   Representation of what a zipper gives with a tree:
   tree = (2 (3 None (4 None None)) (5 None None))
   z = of_tree tree = T (2 (3 None (4 None None)) (5 None None))
   zl = left z = L ((3 None (4 None None)), z)
               = L ((3 None (4 None None)), T (2 (3 None (4 None None)) (5 None None)))
               = L (l1', T (2 (l1) (r1)))
   zup = up zl = Some (set_left (Some l1') z)
               = Some (T (2 (l1') (r1)))

   As we navigate downstream the zipper hold a copy of the node it focus on and
   a copy of the previous zipper. The bottom most zipper state has therefore a
   full record of the path it took. When we go upstream we make the underlying
   node of the parent zipper points to the copy of the underlying node of the
   zipper we go from, so that if a value has changed it is recorded.
 *)

type 'a t = T of 'a Tree.t | L of ('a Tree.t * 'a t) | R of ('a Tree.t * 'a t)
[@@deriving sexp]
(* Automatically creates t_of_sexp and sexp_of_t functions *)

let rec equal veq a b =
  match (a, b) with
  | T node1, T node2 -> Tree.equal veq node1 node2
  | L (na, za), L (nb, zb) | R (na, za), R (nb, zb) ->
      Tree.equal veq na nb && equal veq za zb
  | _, _ -> false

let of_tree node = T node

(** unwrap the focused node held in the zipper *)
let unwrap = function T node | L (node, _) | R (node, _) -> node

let map ~f = function
  | T node -> T (f node)
  | L (node, z) -> L (f node, z)
  | R (node, z) -> R (f node, z)

let set_value value = map ~f:(fun node -> { node with value })
let set_left left = map ~f:(fun node -> { node with left })
let set_right right = map ~f:(fun node -> { node with right })

let up = function
  | T _ -> None
  | L (node, z) -> Some (set_left (Some node) z)
  | R (node, z) -> Some (set_right (Some node) z)

let rec to_tree z = match up z with None -> unwrap z | Some z -> to_tree z
let value z = (unwrap z).value
let left z = Option.map (unwrap z).left ~f:(fun node -> L (node, z))
let right z = Option.map (unwrap z).right ~f:(fun node -> R (node, z))
