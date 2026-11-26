fun append ([], b) = b : int list
  | append (head :: tail, b) = head :: append (tail, b)

fun concat [] = [] : int list
  | concat (head :: tail) = append(head, concat tail)

fun reverse (list: int list): int list =
  let
    fun loop ([], acc) = acc
      | loop (head :: tail, acc) = loop (tail, head :: acc)
  in
    loop (list, [])
  end

fun filter (_, []) = [] : int list
  | filter (p, head :: tail) = if p head then head :: filter (p, tail) else filter (p, tail)

fun map (_, []) = [] : int list
  | map (f, head :: tail) = (f head) :: map (f, tail)

fun length [] = 0
  | length (_ :: tail) = 1 + length tail

fun foldl (_, acc, []) = acc : int
  | foldl (f, acc, head :: tail) = foldl (f, f (acc, head), tail)

fun foldr (_, acc, []) = acc : int
  | foldr (f, acc, head :: tail) = f (head, foldr (f, acc, tail))
