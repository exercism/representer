(* ---------------------------------------------------------------------------
   exercism.io
   SML Track Exercise: atbash-cipher
   Contributed: Anthony J. Borla (ajborla@bigpond.com)
 -------------------------------------------------------------------------- *)

val ord_a = ord(#"a")
val ord_z = ord(#"z")
val ord_z_minus_a = ord_z - ord_a

fun convert (c : char) : char =
  let
    val ord_val = ord(c)
   in
    if ord_val >= ord_a then
      if ord_val <= ord_z then
        chr(ord_a + (ord_z_minus_a - (ord_val - ord_a)))
      else c
    else c
  end

fun sanitize (s : string) : string =
  let
    val f = fn c => (not (Char.isSpace(c)))
    val g = fn c => (not (Char.isPunct(c)))
    val s_as_list = List.filter (f) (explode(String.map Char.toLower s))
    val s_as_list' = List.filter (g) (s_as_list)
  in
    implode(s_as_list')
  end

fun add_spaces_n [] _ _ = ""
  | add_spaces_n [c] _ _ = String.str c
  | add_spaces_n (c :: cs) N n =
      if n = N then (String.str c) ^ " " ^ add_spaces_n cs N 1
      else (String.str c) ^ add_spaces_n cs N (n + 1)

fun decode (phrase : string) : string =
  String.map convert (sanitize phrase)

fun encode (phrase : string) : string =
  add_spaces_n (explode (decode phrase)) 5 1

