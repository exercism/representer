(* fun rebase (inBase: int, outBase: int, digits: int list): int list option = *)

fun getNumber inBase digits =
    foldl (fn (x,y) => x + inBase * y) 0 digits

fun putNumber' outbase n acc =
    if n = 0 then
        acc
    else
        let
            val q = n div outbase
            val m = n mod outbase
        in
            putNumber' outbase q (m::acc)
        end

fun putNumber outbase n =
    putNumber' outbase n []

fun rebase (_, _, []) = NONE
  | rebase (inBase, outBase, digits) =
    if inBase <= 1 orelse outBase <= 1 orelse not (List.all (fn x => x >= 0 andalso x < inBase) digits)
    then
        NONE
    else
        let
            val n = getNumber inBase digits
        in
            (* this is odd, why not just let 0 be expressed, but necessary for the tests *)
            if n = 0 then NONE else SOME (putNumber outBase n)
        end
