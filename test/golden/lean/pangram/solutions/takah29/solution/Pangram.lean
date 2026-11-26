namespace Pangram

def isPangram (sentence : String) : Bool :=
  let s := sentence.toLower.toList
  "abcdefghijklmnopqrstuvwxyz".all (· ∈ s)

end Pangram
