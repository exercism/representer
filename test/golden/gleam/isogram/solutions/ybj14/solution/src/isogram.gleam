import gleam/string
import gleam/list

pub fn is_isogram(phrase phrase: String) -> Bool {
  phrase
  |> string.uppercase
  |> string.split("")
  |> list.filter(fn(item) { item != " " && item != "-" })
  |> fn(chars) { chars == list.unique(chars) }
}