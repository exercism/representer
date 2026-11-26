fun isBalanced s =
  let
    fun eq c c' = c = c'
    fun isOpenBrace c = CharVector.exists (eq c) "[{("
    fun isBrace c = CharVector.exists (eq c) "[{()}]"
    fun matching (c, c') = String.isSubstring (str c ^ str c') "[]{}()"
    fun step (c, stack) =
      if not (isBrace c) then
        stack
      else if isOpenBrace c then
        c :: stack
      else (* if isCloseBrace c then *)
        case stack of
          [] => raise Match
        | c' :: rest => if matching (c', c) then rest
                        else raise Match
  in
    null (CharVector.foldl step [] s) handle Match => false
  end
