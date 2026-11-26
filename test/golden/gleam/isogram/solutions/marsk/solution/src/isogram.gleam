import gleam/string
import gleam/list

fn compare_graph(list:List(a)) -> Bool {
  case list {
    [] -> True
    [first,..rest] -> {
      case list.filter(rest, fn(x) { x == first }) {
        [] -> compare_graph(rest)
        _ -> False
      }
    }
  }
}

pub fn is_isogram(phrase phrase: String) -> Bool {
  phrase
  |> string.lowercase
  |> string.to_graphemes
  |> list.filter(fn(graph) { graph != " " && graph != "-" })
  |> compare_graph
}
