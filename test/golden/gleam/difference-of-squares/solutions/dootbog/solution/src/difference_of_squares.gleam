pub fn square_of_sum(n: Int) -> Int {
  {n + 1} * n / 2 * {n + 1} * n / 2
}

pub fn sum_of_squares(n: Int) -> Int {
  {n * 2 + 1} * {n + 1} * n / 6
}

pub fn difference(n: Int) -> Int {
  square_of_sum(n) - sum_of_squares(n)
}
