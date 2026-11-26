import gleam/list

pub fn factors(value: Int) -> List(Int) {
  do_factors(value, 2, [])
}

fn do_factors(value: Int, factor: Int, factors: List(Int)) -> List(Int) {
  case value {
    1 -> list.reverse(factors)
    n if n < 1 -> panic
    _ ->
      case value % factor == 0 {
        True -> do_factors(value / factor, factor, [factor, ..factors])
        False -> do_factors(value, factor + 1, factors)
      }
  }
}
