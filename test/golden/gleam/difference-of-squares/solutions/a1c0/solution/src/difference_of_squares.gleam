import gleam/int
import gleam/list
import gleam/result

// 1,2 = 3
// 1,2,3 = 6
// 1,2,3,4 = 10 = (4/2)*(4+1)
// 1,2,3,4,5 = 15
// 1,2,3,4,5,6 = 21 = (6/2)*(6+1)
// 1,2,3,4,5,6,7 = 28 = ( odd(n) ? s(n-1)+n : s(n) )^2
pub fn square_of_sum(n: Int) -> Int {
  let x = sum_of(n)
  x * x
}

fn sum_of(n: Int) -> Int {
  case int.is_odd(n) {
    True -> sum_of_even(n - 1) + n
    False -> sum_of_even(n)
  }
}

fn sum_of_even(n: Int) -> Int {
  int.multiply(n / 2, n + 1)
}

// 1 = 1
// 1,4 = 5
// 1,4,9 = 14
pub fn sum_of_squares(n: Int) -> Int {
  list.range(1, n)
  |> list.reduce(fn(acc, x) { acc + x * x })
  |> result.unwrap(0)
}

pub fn difference(n: Int) -> Int {
  square_of_sum(n) - sum_of_squares(n)
}
