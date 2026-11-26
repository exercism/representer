import gleam/dict
import gleam/list
import gleam/string

pub fn is_pangram(sentence: String) -> Bool {
  // used fact that only letters have uppper and lower cases
  string.lowercase(sentence)
  |> string.split("")
  |> list.filter(fn(x) { x != " " && string.uppercase(x) != x })
  |> list.group(fn(x) { x })
  |> dict.size
  != 26
}
