module type ELEMENT = sig
  type t
  val compare : t -> t -> int
end

module Make(El: ELEMENT) = struct
  type t = El.t list
  type el = El.t

  let el_equal e1 e2 = compare e1 e2 = 0

  let is_empty = function
    | [] -> true
    | _ -> false

  let rec is_member list elem = match list with
    | [] -> false
    | h :: t -> if el_equal h elem then true
      else is_member t elem

  let is_subset l1 l2 = if List.length l1 > List.length l2
    then false
    else List.for_all (is_member l2) l1

  let is_disjoint l1 l2 = List.for_all (fun e -> not (is_member l2 e)) l1

  let equal l1 l2 = if List.compare_lengths l1 l2 = 0 
    then List.for_all (is_member l2) l1
    else false

  let rec of_list = function
    | [] -> []
    | h::t -> h :: (of_list t)

  let rec add l e = if not (is_member l e)
    then match l with
      | [] -> [e]
      | h :: t -> h::(add t e)
    else l

  type status = [
    | `OnlyA
    | `OnlyB
    | `Both
  ]

  let diff_filter (f: (status -> bool)) l1 l2 = if f `OnlyA 
    then l1

    else if f `OnlyB 
    then l2

    else l1 @ l2

  let rec difference l1 l2 = match l1 with
    | [] -> []
    | h :: t -> if not (is_member l2 h) then h ::(difference t l2)
      else difference t l2

  let rec intersect l1 l2 = match l1 with
    | [] -> []
    | h :: t -> if is_member l2 h then h :: (intersect t l2)
      else intersect t l2

  let rec union l1 l2 = match l1 with
    | [] -> [] @ l2
    | h :: t -> if (is_member l1 h) <> (is_member l2 h) then h::(union t l2)
      else union t l2
end
