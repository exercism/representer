/// Check a Luhn checkdigit_sum.
pub fn is_valid(code: &str) -> bool {
  let mut digit_sum = 0;
  let mut digit_count = 0;
  let iter = code
    .chars()
    .rev()
    .filter(|c| !c.is_whitespace())
    .zip([false, true].iter().cycle());
  for (c, &should_double) in iter {
    match c.to_digit(10) {
      None => return false,
      Some(digit) => {
        digit_sum += if should_double {
          let doubled = digit * 2;
          if doubled > 9 {
            doubled - 9
          } else {
            doubled
          }
        } else {
          digit
        }
      }
    }
    digit_count += 1;
  }
  digit_count > 1 && digit_sum % 10 == 0
}
