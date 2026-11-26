import gleam/int

pub fn square_of_sum(n: Int) -> Int {
  let result = sum(n, 0)
  result * result
}

fn sum(n: Int, accumulator: Int) -> Int {
  case n {
    0 -> accumulator
    x -> sum(n - 1, accumulator + x)
  }
}

pub fn sum_of_squares(n: Int) -> Int {
  case n {
    0 -> 0
    x -> x * x + sum_of_squares(x - 1)
  }
}

pub fn difference(n: Int) -> Int {
  square_of_sum(n) + sum_of_squares(n)
}
