(* ---------------------------------------------------------------------------
   exercism.io
   SML Track Exercise: perfect-numbers
   Contributed: Anthony J. Borla (ajborla@bigpond.com)
 -------------------------------------------------------------------------- *)

fun compute_aliquot_sum' (dividend, divisor, limit, sum) =
  if divisor > limit then sum + 1
  else let
    val remainder = dividend mod divisor
    val dividend' = dividend div divisor
  in
    if remainder = 0 then
      if divisor = dividend' then
        compute_aliquot_sum' (dividend, divisor + 1, limit, sum + divisor)
      else
        compute_aliquot_sum' (dividend, divisor + 1, limit, sum + divisor + dividend')
    else
      compute_aliquot_sum' (dividend, divisor + 1, limit, sum)
  end

fun compute_aliquot_sum (1) = 0
  | compute_aliquot_sum (n) =
      compute_aliquot_sum' (n, 2, (Real.trunc (Math.sqrt (Real.fromInt n))), 0)

datatype classification = Abundant | Deficient | Perfect

fun classify (input : int) : classification option =
  if input < 1 then NONE
  else let
    val aliquot_sum = compute_aliquot_sum input
  in
    if aliquot_sum < input then SOME(Deficient)
    else if aliquot_sum = input then SOME(Perfect)
    else SOME(Abundant)
  end

