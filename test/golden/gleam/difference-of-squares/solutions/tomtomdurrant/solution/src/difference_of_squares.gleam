pub fn square_of_sum(n: Int) -> Int {
  let value = case n {
    1 -> 1
    num -> num * { num + 1 } / 2
  }

  value * value
}

pub fn sum_of_squares(n: Int) -> Int {
  case n {
    1 -> 1
    n -> {
      n * { n + 1 } * { 2 * n + 1 } / 6
    }
  }
}

pub fn difference(n: Int) -> Int {
  square_of_sum(n) - sum_of_squares(n)
}
