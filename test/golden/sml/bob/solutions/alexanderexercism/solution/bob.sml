fun response s = 
  let
    fun reply ([], true, false, _, _) = "Sure."
      | reply ([], true, true, true, _) = "Sure."
      | reply ([], false, true, false, _) = "Whoa, chill out!"
      | reply ([], true, true, false, _) = "Calm down, I know what I'm doing!"
      | reply ([], _, _, _, true) = "Fine. Be that way!"
      | reply ([], _, _, _, _) = "Whatever."
      | reply (x::xs: char list, question: bool, hasLetter: bool, hasLowerLetter: bool, nothing: bool) =
        let
          val alphabet = "abcdefghijklmnopqrstuvwxyz"
          val silence = " \t\n\r"
          val xLow = Char.toLower x
          val isLetter = Char.contains alphabet xLow
          val isSilence = Char.contains silence x
          val question = question andalso isSilence orelse x = #"?"
          val hasLetter = hasLetter orelse isLetter
          val hasLowerLetter = hasLowerLetter orelse isLetter andalso x = xLow
          val nothing = if not isSilence then false else nothing
        in
          reply (xs, question, hasLetter, hasLowerLetter, nothing)
        end
  in
    reply (String.explode s, false, false, false, true)
  end
