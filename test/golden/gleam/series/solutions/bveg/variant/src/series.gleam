import gleam/list
import gleam/string

pub fn slices(input: String, size: Int) -> Result(List(String), Error) {
  case string.length(input), size {
      i, _ if i==0 -> Error(EmptySeries)
      _, s if s==0 -> Error(SliceLengthZero)
      _, s if s<0 -> Error(SliceLengthNegative)
      i, s if s>i -> Error(SliceLengthTooLarge)
      _, _ -> Ok(get_sets(input, size))
  }
 
}

fn get_sets(input: String, size: Int) -> List(String) {
  string.to_graphemes(input) |> list.window(size) |> list.filter(string.concat)
}

pub type Error {
  EmptySeries
  SliceLengthNegative
  SliceLengthZero
  SliceLengthTooLarge
}
