import Std

open Std (HashMap)

namespace Anagram

private def normalize (word: String): String :=
  word.toList.map Char.toLower |>.mergeSort |> String.ofList

def findAnagrams (subject : String) (candidates : List String) : List String :=
  let subj := normalize subject
  candidates.filter fun word =>
    (subject.toLower != word.toLower) && (subj == normalize word)

end Anagram
