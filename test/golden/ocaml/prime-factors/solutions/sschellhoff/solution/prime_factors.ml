(** Prime-factors exercise *)

(** Return the prime factors for the number, ordered lowest to highest. *)
let factors_of number =
    let rec worker factor rest acc =
        if (Int64.equal rest 1L) || (Int64.compare factor rest) = 1 then
            acc
        else if Int64.equal (Int64.rem rest factor) 0L then
                worker factor (Int64.div rest factor) (factor::acc)
        else
            worker (Int64.add factor 1L) rest acc
    in
    List.sort Int64.compare (worker 2L number [])
