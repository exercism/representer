import gleam/list
import gleam/string

pub fn recite(inputs: List(String)) -> String {
  let initial_verses =
    inputs
    |> list.window_by_2
    |> list.map(fn(pair) {
      let #(a, b) = pair
      "For want of a " <> a <> " the " <> b <> " was lost."
    })

  case inputs {
    [] -> ""
    [first] -> "And all for the want of a " <> first <> "."
    _ -> {
      let assert Ok(first) = list.first(inputs)
      let final_verse = "And all for the want of a " <> first <> "."
      string.join(initial_verses, "\n") <> "\n" <> final_verse
    }
  }
}
