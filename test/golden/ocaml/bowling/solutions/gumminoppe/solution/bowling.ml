
type throw =
  | First_of of int   (* The first throw of frame n *)
  | Second_of of int  (* The second throw of frame n *)
  | Third_of_10       (* The bonus fill throw of frame 10 *)
  | Game_ended        (* Game has ended, throw impossible *)

type bonus =
  | No_bonus        (* No extra points at start or after an open frame *)
  | After_spare     (* Double bonus after a spare *)
  | After_strike    (* Double bonus after a strike *)
  | After_2strikes  (* Triple bonus after two strikes *)

type t =
  { score : int;     (* The total score so far *)
    avail : int;     (* The number of available pins on the lane *)
    throw : throw;   (* The next throw: 1st or 2nd of frame number *)
    bonus : bonus }  (* The extra bonus points from previous frames *)

let new_game =
  { score = 0;
    avail = 10;
    throw = First_of 1;
    bonus = No_bonus }

let roll pins { score; avail; throw; bonus } =
  let open Result in
  if pins < 0 then error "Negative roll is invalid"
  else if pins > avail then error "Pin count exceeds pins on the lane"
  else
    match throw with
    | Game_ended -> error "Cannot roll after game is over"
    | Third_of_10 ->
        ok { score = score + pins;
             avail = 10;
             throw = Game_ended;
             bonus = No_bonus }
    | Second_of 10 ->
        ok { score = score
                   + (match bonus with
                      | After_2strikes -> 2 * pins
                      | _ -> pins);
             avail = if pins = avail then 10 else avail - pins;
             throw = (match bonus with
                      | No_bonus when pins < avail -> Game_ended
                      | _ -> Third_of_10);
             bonus = No_bonus }
    | Second_of i ->
        ok { score = score
                   + (match bonus with
                      | After_strike | After_2strikes -> 2 * pins
                      | _ -> pins);
             avail = 10;
             throw = First_of (i + 1);
             bonus = if pins = avail then After_spare else No_bonus }
    | First_of i ->
        ok { score = score
                   + (match bonus with
                      | After_2strikes -> 3 * pins
                      | After_strike | After_spare -> 2 * pins
                      | No_bonus -> pins);
             avail = if pins = avail then 10 else avail - pins;
             throw = if i < 10 && pins = avail
                     then First_of (i + 1)
                     else Second_of i;
             bonus = (match bonus with
                      | After_2strikes | After_strike ->
                          if pins = avail
                          then After_2strikes
                          else After_strike
                      | After_spare | No_bonus ->
                          if pins = avail
                          then After_strike
                          else No_bonus) }

let score =
  let open Result in
  function
    | { score; throw = Game_ended; _ } -> ok score
    | _ -> error "Score cannot be taken until the end of the game"

