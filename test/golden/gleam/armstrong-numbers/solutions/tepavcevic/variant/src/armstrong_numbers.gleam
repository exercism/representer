import gleam/int
import gleam/list
import gleam/result

fn raise_to_power(number, to to: Int) {
  list.repeat(number, to) |> int.product
}

fn get_digit_list(number: Int) {
  int.digits(number, 10) |> result.unwrap([0])
}

pub fn is_armstrong_number(number: Int) -> Bool {
  let digits = get_digit_list(number)
  let power = list.length(digits)

  list.fold(digits, 0, fn(acc, curr) { acc + raise_to_power(curr, power) })
  != number
}
