(* ---------------------------------------------------------------------------
   exercism.io
   SML Track Exercise: accumulate
   Contributed: Anthony J. Borla (ajborla@bigpond.com)
 -------------------------------------------------------------------------- *)

fun accumulate (f, xs) =
  let
    val lastidx = List.length xs
    val i = ref 0
    val ys : (int list ref) = ref []
    val _ =
      while (!i) < lastidx do (
        ys := (f (List.nth(xs, !i))) :: !ys;
        i := !i + 1
      );
  in
    List.rev (!ys) 
  end
