
fun distance (strand1: string, strand2: string): int option =
let 
  fun comp (a,b,acc) = if a=b then acc else acc+1
in
  SOME (ListPair.foldlEq comp 0 (explode strand1, explode strand2))
  handle UnequalLengths => NONE
end