(* stack is char stack for '[]{}()'  *)
let rec scan target stack =
 match ( target, stack ) with
    ( [],      [])       -> true              (* target is end and stack is empty *)
  | ( [],      s)        -> false             (* target is end but stack is not empty *)
  | ('{' :: t, s)        -> scan t ('{' :: s) (* push { to stack *)
  | ('[' :: t, s)        -> scan t ('[' :: s) (* push [ to stack *)
  | ('(' :: t, s)        -> scan t ('(' :: s) (* push ( to stack *)
  | ('}' :: t, '{' :: s) -> scan t s (* matched *)
  | ('}' :: t, s)        -> false    (* unmatched *)
  | (']' :: t, '[' :: s) -> scan t s (* matched *)
  | (']' :: t, s)        -> false    (* unbalanced *)
  | (')' :: t, '(' :: s) -> scan t s (* matched *)
  | (')' :: t, s)        -> false    (* unbalanced *)
  | ( _  :: t, s)        -> scan t s;; (* other char / ignored *)

(* convert string to char list *)
let explode s =
 let rec exp i l =
   if i < 0 then l else exp (i + 1) (s.[i] :: l) in
   exp (String.length s - 1) [];;

let are_balanced str =
  scan (explode str) [];;    
