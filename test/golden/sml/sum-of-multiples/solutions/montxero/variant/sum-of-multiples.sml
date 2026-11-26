(* sum-of-multiples *)
(* an exercism exercise *)

val map = List.map
val concat = List.concat
val foldl = List.foldl
val find = List.find
               


fun mults start stop =
    let
        fun aux x acc =
            if x >= stop then acc
            else aux (x+start) (x::acc)
    in
        aux start []
    end

fun dedup xs =
    let
        fun aux ys acc =
            case ys of
                [] => acc
              | y::ys' => case find (fn z => y=z) ys' of
                             SOME z => aux ys' acc
                           | _ => aux ys' (y::acc)
    in
        aux xs []
    end


fun sum (factors: int list, limit: int): int =
    foldl (op +) 1 (dedup (concat (map (fn n => mults n limit) factors)))
