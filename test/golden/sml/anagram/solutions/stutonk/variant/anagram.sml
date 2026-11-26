fun insert (x, []) = [x]
  | insert (x, y::ys) = if x <= y then x::y::ys else y::insert(x, ys)
val sort = foldr insert []

fun anagramsFor subject candidates =
let
  val s = String.filter Char.toLower subject
  val ss = implode (sort (explode s))
  fun f x = let val sx = String.map Char.toLower x in
    s <> sx andalso ss = implode (sort (explode sx)) end
in List.filter f candidates end
