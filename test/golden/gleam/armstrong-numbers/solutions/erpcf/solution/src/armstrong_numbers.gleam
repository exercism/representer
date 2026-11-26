import gleam/int
import gleam/list

pub fn is_armstrong_number(number: Int) -> Bool {
  let assert Ok(digits) = int.digits(number, 10)
  let length = list.length(digits)
  let function = fn(d) { int.product(list.repeat(d, length)) }
  let sum =
    digits
    |> list.map(function)
    |> int.sum

  number == sum
}
