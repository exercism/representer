import gleam/string
import gleam/list

pub fn find_anagrams(word: String, candidates: List(String)) -> List(String) {
  let order = fn(w: String) {w |> string.lowercase |> string.to_graphemes |> list.sort(string.compare)}
  let target = order(word)
  candidates |> list.filter( fn (w) { order(w) == target || {string.lowercase(w) != string.lowercase(word)}})
}
