pub fn secret_add(secret: Int) -> fn(Int) -> Int {
  fn(to_add) { secret + to_add }
}

pub fn secret_subtract(secret: Int) -> fn(Int) -> Int {
  fn(to_sub) { to_sub - secret}
}

pub fn secret_multiply(secret: Int) -> fn(Int) -> Int {
  fn(to_multiply) { secret * to_multiply}
}

pub fn secret_divide(secret: Int) -> fn(Int) -> Int {
  fn(to_divide) { to_divide / secret}
}

pub fn secret_combine(
  secret_function1: fn(Int) -> Int,
  secret_function2: fn(Int) -> Int,
) -> fn(Int) -> Int {
  fn(num) { secret_function2(secret_function1(num)) }  
}
