pub fn do_square_of_sum(n: Int, acc: Int) -> Int {
  case n {
    n if n == 0 -> acc * acc
    _ -> do_square_of_sum(n - 1, acc + n)
  }
}

pub fn square_of_sum(n: Int) -> Int {
  n
  |> do_square_of_sum(0)
}

pub fn do_sum_of_squares(n: Int, acc: Int) -> Int {
  case n {
    n if n == 0 -> acc
    _ -> do_sum_of_squares(n - 1, acc + n * n)
  }
}

pub fn sum_of_squares(n: Int) -> Int {
  n
  |> do_sum_of_squares(0)
}

pub fn difference(n: Int) -> Int {
  square_of_sum(n) - sum_of_squares(n)
}
