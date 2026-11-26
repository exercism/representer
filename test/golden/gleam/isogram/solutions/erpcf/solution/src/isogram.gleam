import gleam/string
import gleam/list

pub fn is_isogram(phrase phrase: String) -> Bool {
  let letters =
    phrase
    |> string.lowercase
    |> string.to_graphemes
    |> list.filter(fn(l) { string.contains("abcdefghijklmnopqrstuvwxyz", l) })

  list.length(letters) == {
    letters
    |> list.unique
    |> list.length
  }
}
