import Std.Data.Iterators

namespace Pangram

def isPangram (sentence : String) : Bool :=
  let sentence := sentence.toLower
  ('a'...='z').iter.all (sentence.contains ·)

end Pangram
