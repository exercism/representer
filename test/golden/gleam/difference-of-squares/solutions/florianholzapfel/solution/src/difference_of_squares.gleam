import gleam/float
import gleam/int
import gleam/list

pub fn square_of_sum(n: Int) -> Int {
  let result = list.range(1, n)
  |> int.sum()
  |> int.power(2.0)

  case result {
    Ok(x) -> float.round(x)
    Error(Nil) -> 0
  }
}

pub fn sum_of_squares(n: Int) -> Int {
  let result = list.range(1, n)
  |> list.map(fn(x) {
    case int.power(x, 2.0) {
      Ok(x) -> float.round(x)
      Error(Nil) -> 0
    }
  })
  |> int.sum()
}

pub fn difference(n: Int) -> Int {
  square_of_sum(n) - sum_of_squares(n)
}
