import gleam/string
import gleam/list

pub fn slices(input: String, size: Int) -> Result(List(String), Error) {
  case string.length(input) {
    _ if size == 0 -> Error(SliceLengthZero)
    _ if size < 0 -> Error(SliceLengthNegative)
    0 -> Error(EmptySeries)
    len if len < size -> Error(SliceLengthTooLarge)
    _ ->
      input
      |> string.to_graphemes
      |> list.window(size)
      |> list.map(string.concat)
      |> Ok()
  }
}

pub type Error {
  SliceLengthTooLarge
  SliceLengthZero
  SliceLengthNegative
  EmptySeries
}
