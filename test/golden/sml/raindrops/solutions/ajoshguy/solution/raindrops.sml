(* fun convert n = *)
(*   let *)
(*     val noises = [(7, "Plong"),(5, "Plang"),(3, "Pling")] *)
(*     fun drop_sounds(acc, noises) = *)
(*       case (noises) of *)
(*            [] => acc *)
(*          | (num, sound)::x' => if n mod num = 0 *) 
(*                                then drop_sounds(sound :: acc, x') *)
(*                                else drop_sounds(acc, x') *)

(*   in *)
(*     case drop_sounds([], noises) of *)
(*          [] => Int.toString(n) *)
(*        | x  => concat(x) *)

(*   end *)

fun convert n =
  let
    val noises = [(3, "Pling"),(5, "Plang"),(7, "Plong")]
    fun sound(i, sn) = if n mod i = 0 then sn else ""
  in
    case concat(List.map sound noises) of 
         "" => Int.toString(n)
       | st => st

  end
