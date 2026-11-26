import gleam/int
import gleam/bool

pub type Error {
  NonPositiveNumber
}

fn step(n, count) {
  case n, int.is_odd(n) {
    1, _     -> count
    _, True  -> step(n*3+1, count+1)
    _, False -> step(n/2, count+1)
  }
}

pub fn steps(number: Int) -> Result(Int, Error) {
  use <- bool.guard(number<=0, Error(NonPositiveNumber))
  Ok(step(number, 0))
}
