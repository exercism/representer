import Std.Data.HashSet

namespace Isogram

def isIsogram (phrase : String) : Bool :=
  loop {} (normalize phrase)
where
  normalize (s : String) : List Char :=
    s.toLower.toList.filter Char.isAlpha

  loop (seen : Std.HashSet Char) : List Char → Bool
    | [] => true
    | c :: cs =>
      if seen.contains c then false
      else loop (seen.insert c) cs

end Isogram
