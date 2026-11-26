import gleam/list
import gleam/string

pub fn find_anagrams(word: String, candidates: List(String)) -> List(String) {
  candidates
  |> list.filter(fn(candidate) {
    string.lowercase(word) != string.lowercase(candidate)
  })
  |> list.filter(fn(candidate) {
    string_to_sorted_list(word) == string_to_sorted_list(candidate)
  })
}

fn string_to_sorted_list(s: String) -> List(String) {
  s
  |> string.lowercase
  |> string.to_graphemes
  |> list.sort(by: string.compare)
}
