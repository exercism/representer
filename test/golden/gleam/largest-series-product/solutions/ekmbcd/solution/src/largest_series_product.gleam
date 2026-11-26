import gleam/string
import gleam/list
import gleam/int
import gleam/result


pub fn largest_product(digits: String, span: Int) -> Result(Int, Nil) {
  case span > string.length(digits) {
    True -> Error(Nil)
    _ if span <0 -> Error(Nil)
    _ if span == 0 -> Ok(1)
    _ -> {
      string.to_graphemes(digits)
      |> list.try_map(int.parse)
      |> result.map(list.window(_, span))
      |> result.map(list.map(_, int.product))
      |> result.try(list.reduce(_, int.max))
    }
  }
}
