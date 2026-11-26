open React
open Base

type progress = Win | Lose | Busy of int

type t = {
  lookup : (char, int list, Char.comparator_witness) Map.t;
  progress : progress S.t;
  masked_word : string S.t;
  word : char option array;
  set_progress : progress -> unit;
  set_masked_word : string -> unit;
}

let create w =
  let word = Array.create ~len:(String.length w) None in
  let empty = Map.empty (module Char) in
  let lookup =
    String.to_list w
    |> List.foldi ~init:empty ~f:(fun i acc c ->
           let idx = Map.find_multi acc c in
           Map.set ~key:c ~data:(i :: idx) acc)
  in
  let progress, set_progress = S.create (Busy 9) in
  let masked_word, set_masked_word =
    S.create (Array.map ~f:(fun _ -> "_") word |> String.concat_array)
  in
  { lookup; word; progress; masked_word; set_progress; set_masked_word }

let feed c hm =
  let to_str cs =
    Array.map ~f:(function None -> "_" | Some x -> Char.to_string x) cs
    |> String.concat_array
  in
  let update c r cs =
    let idx = match List.hd r with Some i -> i | None -> -1 in
    if idx < 0 then false
    else
      match cs.(idx) with
      | None ->
          List.iter ~f:(fun i -> cs.(i) <- Some c) r;
          true
      | Some _ -> false
  in
  let next s =
    S.map
      (fun s' ->
        match s' with Busy 0 -> Lose | Busy x -> Busy (x - 1) | _ as p -> p)
      s
  in
  let lose () =
    let cur = S.value (next hm.progress) in
    hm.set_progress cur
  in
  let found = Map.find hm.lookup c in
  match found with
  | None -> lose ()
  | Some x ->
      if update c x hm.word then (
        hm.set_masked_word (to_str hm.word);
        if Array.for_all ~f:(function None -> false | Some _ -> true) hm.word
        then hm.set_progress Win
        else ())
      else lose ()

let masked_word hm = hm.masked_word

let progress hm = hm.progress
