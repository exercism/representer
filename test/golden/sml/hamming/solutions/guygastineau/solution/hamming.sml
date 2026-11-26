structure Hamming :
  sig
      val distance : string * string -> int option
  end
= struct

(* Auxilliary functions *)
structure Aux :
  sig
      val count : int -> char -> char -> int
      val foldl2Exact :
          ('c -> 'a -> 'b -> 'c) -> 'c -> 'a list -> 'b list -> 'c option
  end
= struct

fun count (acc : int) (x : char) (y : char): int =
    if x = y then acc else acc + 1

fun foldl2Exact f acc [] [] = SOME acc
  | foldl2Exact f acc (x::xs) (y::ys) = foldl2Exact f (f acc x y) xs ys
  | foldl2Exact _ _ _ _ = NONE

end

(* External API *)
open Aux

fun distance (strand1, strand2) =
    foldl2Exact Aux.count 0 (explode strand1) (explode strand2)

end

open Hamming
