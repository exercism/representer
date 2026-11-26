(* ---------------------------------------------------------------------------
   exercism.io
   SML Track Exercise: sum-of-multiples
   Contributed: Anthony J. Borla (ajborla@bigpond.com)
 -------------------------------------------------------------------------- *)

fun gen_multiples'(factor, limit, n, multiples) =
  let
    val multiple = factor * n
  in
    if multiple < limit then gen_multiples'(factor, limit, n + 1, multiple :: multiples)
    else multiples
  end

fun gen_multiples (0, _) = [0]
  | gen_multiples (factor, limit) = gen_multiples'(factor, limit, 1, [])

(* Source for sort function: https://stackoverflow.com/questions/14411862/standard-sorting-functions-in-sml *)
fun sort list = foldr (fn (x, lst) => List.filter (fn a => a < x) lst @ [x] @ List.filter (fn a => a >= x) lst) [] list;

(* Source for dedup function: https://stackoverflow.com/questions/21077272/remove-duplicates-from-a-list-in-sml *)
fun dedup [] = []
  | dedup (x :: xs) = x :: dedup(List.filter (fn y => y <> x) xs)

fun sum (factors : int list, limit : int) : int =
  let
    val folder = fn (n, multiples) => gen_multiples(n, limit) @ multiples
    val multiples = List.foldl folder [] factors
    val sum_of_multiples = foldl op+ 0 ((dedup o sort) multiples)
  in
    sum_of_multiples
  end

