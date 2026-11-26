pub fn square_of_sum(n: Int) -> Int {
  let sum_result = sum(n)
  sum_result * sum_result
}

pub fn sum_of_squares(n: Int) -> Int {
  case n {
    1 -> 1
    _ -> n * n + sum_of_squares(n - 1)
  }
}

pub fn difference(n: Int) -> Int {
  square_of_sum(n) - sum_of_squares(n)
}

fn sum(n: Int) -> Int {
  case n {
    1 -> 1
    _ -> n + sum(n - 1)
  }
}
