fn egg_count_recursive(number: Int, acc: Int) {
  case number {
    0 -> acc
    n if n % 2 == 1 -> egg_count_recursive(n / 2, acc - 1)
    n -> egg_count_recursive(n / 2, acc)
  }
}

pub fn egg_count(number: Int) -> Int {
  egg_count_recursive(number, 0)
}
