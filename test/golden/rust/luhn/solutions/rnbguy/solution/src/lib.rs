pub fn is_valid(number: &str) -> bool {
  if !number.chars().all(|c| c.is_whitespace() || c.is_digit(10)) {
    return false;
  }
  let number: String = number.chars().filter(|c| !c.is_whitespace()).collect();
  if number.len() < 2 {
    return false;
  }
  number.as_str()
        .chars()
        .filter_map(|c| c.to_digit(10))
        .rev()
        .enumerate()
        .map(|(i, n)| if i & 1 == 0 {n} else {n << 1})
        .map(|n| if n > 9 {n - 9} else {n})
        .sum::<u32>() % 10 == 0
}