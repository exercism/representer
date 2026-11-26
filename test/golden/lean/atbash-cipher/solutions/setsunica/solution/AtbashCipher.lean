def List.chunk (n : Nat) (hn : 0 < n := by omega) (l : List α) : List (List α) := go hn l [] where
  go (hn : 0 < n) : List α → List (List α) → List (List α)
    | [], acc => acc.reverse
    | l@(_ :: _), acc => go hn (l.drop n) (l.take n :: acc)
  termination_by xs _ => xs.length
  decreasing_by
    simp only [List.length_drop]
    grind

namespace AtbashCipher

def aCodePoint := 'a'.toNat
def zCodePoint := 'z'.toNat

def conv (c : Char) : Char := if c.isDigit then c else zCodePoint - (c.toNat - aCodePoint) |> .ofNat

def encode (phrase : String) : String :=
  phrase.chars.filter (·.isAlphanum) |>.map (·.toLower |> conv) |>.toList |>.chunk 5
    |>.map .ofList |>.intersperse " " |> .join

def decode (phrase : String) : String :=
  phrase.chars.filter (·.isAlphanum) |>.map (·.toLower |> conv) |>.toList |> .ofList

end AtbashCipher