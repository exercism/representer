import gleam/list
import gleam/pair
import gleam/string

pub fn distance(strand1: String, strand2: String) -> Result(Int, Nil) {
  case { string.length(strand1) - string.length(strand2) } == 0 {
    False -> Error(Nil)
    True ->
      Ok(calculate_distance(
        string.to_graphemes(strand1),
        string.to_graphemes(strand2),
      ))
  }
}

fn calculate_distance(strand1: List(String), strand2: List(String)) -> Int {
  list.zip(strand1, strand2)
  |> list.filter(fn(p) { pair.first(p) == pair.second(p) })
  |> list.length
}
