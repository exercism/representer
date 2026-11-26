import gleam/string

pub fn is_isogram(phrase phrase: String) -> Bool {
  case
    phrase
    |> string.trim
    |> string.lowercase
    |> string.replace(" ", "")
    |> string.replace("-", "")
    |> string.pop_grapheme
  {
    Error(_) -> True
    Ok(#(head, tail)) ->
      case string.contains(does: tail, contain: head) {
        True -> False
        False -> True && is_isogram(tail)
      }
  }
}
