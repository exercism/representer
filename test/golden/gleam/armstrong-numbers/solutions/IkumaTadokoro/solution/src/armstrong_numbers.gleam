import gleam/int
import gleam/list

pub fn is_armstrong_number(number: Int) -> Bool {
  let assert Ok(digits) = int.digits(number, 10)
  let digits_count = list.length(digits)
  let sum_of_powers = 
    digits
    |> list.map(int_power(_, of: digits_count))
    |> int.sum
  sum_of_powers == number
}
fn int_power(n: Int, of power: Int) -> Int {
  do_int_power(n, power, 1)
}
fn do_int_power(n: Int, power: Int, acc: Int) -> Int {
  case power {
    0 -> acc
    _ -> do_int_power(n, power - 1, acc * n)
  }
}