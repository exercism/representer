import gleam/int
import gleam/list

pub fn is_armstrong_number(number: Int) -> Bool {
 let assert Ok(digits) = int.digits(number, 10)

 let number_of_digits = list.length(digits)

 let sum = digits |> list.map(int_pow(_, number_of_digits, 1)) |> int.sum

 sum == number

}


fn int_pow(i, n, acc) {
 case n {
  0 -> acc
  n -> int_pow(i, n - 1, acc * i)
 }
}
