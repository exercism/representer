(* hamming.sml *)
(* an exercism exercise *)

fun distance (strand1: string, strand2: string): int option =
    let
        fun aux xs ys acc =
            case (xs,ys) of
                ([], []) => SOME acc
              | (x::xs',y::ys') => if x=y then aux xs' ys' acc
                                  else aux xs' ys' (1+acc)
              | _ => NONE
    in
        aux (explode strand1) (explode strand2) 0
    end

