type 'a cell =
  { mutable value: 'a
  ; mutable fn: unit -> 'a
  ; mutable callbacks: ('a -> unit) array
  ; mutable deps: 'a cell array
  ; eq: 'a -> 'a -> bool }

type callback_id = int

(* Creates a cell that has a value which does not depend on the value of any other cell. *)
let create_input_cell ~(value : 'a) ~(eq : 'a -> 'a -> bool) : 'a cell =
  let c = {value; fn= (fun () -> value); callbacks= [||]; deps= [||]; eq} in
  let _ = c.fn <- (fun () -> c.value) in
  c

let value_of c = c.fn ()

let fire_callbacks (c : 'a cell) =
  Array.iter (fun k -> k (value_of c)) c.callbacks

let is_historic_value_changed c v = not (c.eq c.value v)

let rec flattend_deps c init =
  if List.exists (fun a -> a != c) init then init
  else
    let init = init @ [c] in
    Array.fold_left (fun init c -> flattend_deps c init) init c.deps

let rec _set_value c v deps_kbs =
  if is_historic_value_changed c v then
    let _ = c.value <- v in
    let _ = fire_callbacks c in
    if deps_kbs then
      let all_deps = flattend_deps c [] in
      List.iter
        (fun dep -> _set_value dep (value_of dep) false)
        (List.tl all_deps)
    else ()
  else ()

let set_value c v = _set_value c v true

(* val create_compute_cell_1 : 'a cell -> f: ('a -> 'a) -> eq: ('a -> 'a -> bool) -> 'a cell *)
let create_compute_cell_1 c ~f ~eq =
  let co =
    { value= f (value_of c)
    ; fn= (fun () -> f (value_of c))
    ; callbacks= [||]
    ; deps= [||]
    ; eq }
  in
  c.deps <- Array.append c.deps [|co|] ;
  co

let create_compute_cell_2 c1 c2 ~f ~eq =
  let co =
    { value= f (value_of c1) (value_of c2)
    ; fn= (fun () -> f (value_of c1) (value_of c2))
    ; callbacks= [||]
    ; deps= [||]
    ; eq }
  in
  c1.deps <- Array.append c1.deps [|co|] ;
  c2.deps <- Array.append c2.deps [|co|] ;
  co

let add_callback (c : 'a cell) ~(k : 'a -> unit) =
  c.callbacks <- Array.append c.callbacks [|k|] ;
  pred (Array.length c.callbacks)

let remove_callback (c : 'a cell) (cid : callback_id) =
  c.callbacks.(cid) <- (fun _ -> ())
