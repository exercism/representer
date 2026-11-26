open Base

type t = {
  frame: int;
  throws_left: int;
  pins_left: int;
  scores: int list;
} [@@deriving sexp]

type throw =
  | Strike
  | Spare
  | Standard

let new_game = {
  frame = 1;
  throws_left = 2;
  pins_left = 10;
  scores = [];
}

let to_throw pins game =
  if game.throws_left = 2 && pins = 10 then Strike
  else if game.pins_left - pins = 0 then Spare
  else Standard

let roll pins game =
  if pins < 0 then Error "Negative roll is invalid"
  else if game.throws_left = 0 then Error "Cannot roll after game is over"
  else if game.pins_left < pins then Error "Pin count exceeds pins on the lane"
  else
    let frame = game.frame in
    let pins_left = game.pins_left - pins in
    let throws_left = game.throws_left - 1 in
    let scores = pins :: game.scores in
    let next = match game.frame, game.throws_left, (to_throw pins game) with
      | 11, _, Strike  ->
        { frame; throws_left; pins_left = 10; scores }
      | 11, _, Spare
      | 11, _, Standard  ->
        { frame; throws_left; pins_left; scores; }
      | 10, _, Spare ->
        { frame = frame + 1; throws_left = 1; pins_left = 10; scores }
      | _, _, Strike ->
        { frame = frame + 1; throws_left = 2; pins_left = 10; scores }
      | 10, 1, Standard ->
        { frame = frame + 1; throws_left = 0; pins_left = 10; scores }
      | _, 1, _ ->
        { frame = frame + 1; throws_left = 2; pins_left = 10; scores }
      | _, _, Standard ->
        { frame = frame; throws_left; pins_left; scores }
      | _ -> assert false
    in Ok next

let frame_scores scores =
  let rec loop acc l =
    match l with
    | [x; x1] ->
      (x + x1) :: acc
    | [x; x1; x2] ->
      (x + x1 + x2) :: acc
    | x :: x1 :: x2 :: xs when x = 10 ->
      loop (x + x1 + x2 :: acc) (x1 :: x2 :: xs)
    | x :: x1 :: x2 :: xs when x + x1 = 10 ->
      loop (10 + x2 :: acc) (x2 :: xs)
    | x :: x1 :: x2 :: xs ->
      loop (x + x1 :: acc) (x2 :: xs)
    | _ -> assert false in
  loop [] scores

let score game =
  if game.throws_left > 0
  then Error "Score cannot be taken until the end of the game"
  else
    List.rev game.scores
    |> frame_scores
    |> List.fold ~init:0 ~f:(+)
    |> (fun n -> Ok n)

