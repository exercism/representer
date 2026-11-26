//// Code for the “Difference of Squares” exercice on Exercism’s Gleam Track

import gleam/int
import gleam/list

pub fn square_of_sum(n: Int) -> Int {
  list.range(1, n)
  |> int.sum
  |> fn(nb) { nb * nb }
}

pub fn sum_of_squares(n: Int) -> Int {
  list.range(1, n)
  |> list.fold(from: 0, with: fn(acc, curr) { acc + curr * curr })
}

pub fn difference(n: Int) -> Int {
  square_of_sum(n) - sum_of_squares(n)
}
