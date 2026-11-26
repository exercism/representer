import gleam/string

pub fn is_paired(value: String) -> Bool {
  paired(string.to_graphemes(value), [])
}

fn paired(list: List(String), stack: List(String)) -> Bool {
  case list, stack {
    [], [] -> True
    [], _ -> False

    [v, ..vs], [] ->
      case v {
        ")" | "]" | "}" -> False
        "(" | "[" | "{" -> paired(vs, [v])
        _ -> paired(vs, [])
      }
    [v, ..vs], [w, ..ws] ->
      case w, v {
        _, "(" | _, "[" | _, "{" -> paired(vs, [v, ..stack])
        "(", ")" -> paired(vs, ws)
        "[", "]" -> paired(vs, ws)
        "{", "}" -> paired(vs, ws)
        _, ")" | _, "]" | _, "}" -> False
        _, _ -> paired(vs, stack)
      }
  }
}
