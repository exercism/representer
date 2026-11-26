import gleam/list
import gleam/int
import gleam/float

fn square (n: Int) -> Int {
  n * n
}

pub fn square_of_sum(n: Int) -> Int {
  square(list.fold(list.range(0, n), 0, int.add))
}

fn square_and_add (acc: Int, curr: Int) -> Int {
  acc + square(curr)
}

pub fn sum_of_squares(n: Int) -> Int {
  list.fold(list.range(0, n), 0, square_and_add)
}

pub fn difference(n: Int) -> Int {
  square_of_sum(n) - sum_of_squares(n)
}
