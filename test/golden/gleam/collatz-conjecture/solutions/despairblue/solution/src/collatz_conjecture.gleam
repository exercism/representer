import gleam/int

pub type Error {
  NonPositiveNumber
}

pub fn steps(number: Int) -> Result(Int, Error) {
  case number {
    n if n <= 0 -> Error(NonPositiveNumber)
    _ -> Ok(count_steps(number, 0))
  }
}

fn count_steps(number: Int, steps: Int) -> Int {
  case number, int.is_even(number) {
    1, _ -> steps
    _, True -> count_steps(number / 2, steps + 1)
    _, False -> count_steps(3 * number + 1, steps + 1)
  }
}
