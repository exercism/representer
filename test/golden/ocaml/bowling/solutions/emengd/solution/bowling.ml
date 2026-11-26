open Base

type throw =
  | First
  | Second
  | Fill_ball

type frame_state = {
  frame: int;
  throw: throw;
  bonus: int list;
  pins: int;
  score: int;
}

type t =
  | Finished of int (* score *)
  | Frame of frame_state

let new_game =
  Frame {
    frame = 1;
    throw = First;
    bonus = [];
    pins = 10;
    score = 0;
  }

let evaluate_throw pins state =
  let base_multiplier =
    match state.throw with
    | Fill_ball -> 0
    | First | Second -> 1
  in
  let multiplier, bonus =
    match state.bonus with
    | [] -> (base_multiplier, [])
    | bonus :: rest -> (bonus + base_multiplier, rest)
  in
  { state with
    score = state.score + pins * multiplier;
    bonus;
    pins = state.pins - pins;
  }

let add_bonus state =
  if state.pins > 0 then
    state
  else
    let bonus =
      match state.throw, state.bonus with
      | First, [] -> [1; 1]
      | First, [b] -> [b + 1; 1]
      | Second, [] -> [1]
      | Fill_ball, l -> l (* do not add bonuses in fill balls *)
      | _ -> assert false
    in
    { state with bonus }

let advance state =
  let next_frame state =
    if state.frame = 10 then
      if List.is_empty state.bonus then
        Finished state.score
      else
        Frame { state with
                throw = Fill_ball;
                pins = if state.pins = 0 then 10 else state.pins;
              }
    else
      Frame { state with
              frame = state.frame + 1;
              throw = First;
              pins = 10;
            }
  in
  match state.throw with
  | Second | Fill_ball -> next_frame state
  | First ->
    if state.pins = 0 then
      next_frame state
    else
      Frame { state with throw = Second }

let roll pins game =
  if pins < 0 then
    Error "Negative roll is invalid"
  else
    match game with
    | Finished _ ->
      Error "Cannot roll after game is over"
    | Frame state ->
      if pins > state.pins then
        Error "Pin count exceeds pins on the lane"
      else
        state
        |> evaluate_throw pins
        |> add_bonus
        |> advance
        |> Result.return


let score game =
  match game with
  | Finished score ->
    Ok score
  | Frame _ ->
    Error "Score cannot be taken until the end of the game"
