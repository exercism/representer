
fun sound(n: int, factor: int, str: string): string =
  if n mod factor = 0
  then str
  else ""

fun convert n =
  let
    val sounds = sound(n, 3, "Pling") ^ sound(n, 5, "Plang") ^ sound(n, 7, "Plong")
  in
    if sounds = ""
    then Int.toString(n)
    else sounds
  end
