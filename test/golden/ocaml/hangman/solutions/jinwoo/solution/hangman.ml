open Base
open React

type progress =
  | Win
  | Lose
  | Busy of int

type t = {
  feed : char -> unit;
  mask : string signal;
  progress : progress signal;
}

let mask_fn word prev cin =
  String.mapi prev ~f:(fun i ch ->
      if Char.(word.[i] = cin) then cin else ch)

let progress_fn mask counter =
  if String.contains mask '_' then
    match counter with
    | n when n >= 0 -> Busy n
    | _ -> Lose
  else Win

let create word =
  let (input, feed) = E.create () in
  let init_mask = String.make (String.length word) '_' in
  let mask_ev = E.fold (mask_fn word) init_mask input in
  let mask = S.hold init_mask mask_ev in
  let wrong_ev =
    E.map (fun cin ->
        not (String.contains word cin) || String.contains (S.value mask) cin)
      input
  in
  let counter =
    S.fold ~eq:(=)
      (fun prev is_wrong -> if is_wrong then prev - 1 else prev)
      9 wrong_ev
  in
  let progress = S.l2 progress_fn mask counter in
  { feed; mask; progress }

let feed ch { feed } = feed ch

let masked_word { mask } = mask

let progress { progress } = progress