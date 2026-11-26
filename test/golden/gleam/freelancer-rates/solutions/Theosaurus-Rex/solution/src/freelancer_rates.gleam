import gleam/int
import gleam/float

pub fn daily_rate(hourly_rate: Int) -> Float {
  int.to_float(hourly_rate) *. 8.0
}

pub fn apply_discount(before_discount: Int, discount: Float) -> Float {
  let initial_price = int.to_float(before_discount) 
  initial_price -. initial_price *. { discount /. 100.0 }
}

pub fn monthly_rate(hourly_rate: Int, discount: Float) -> Int {
  let before_discount = float.round(daily_rate(hourly_rate) *. 22.0)
  let after_discount = apply_discount(before_discount, discount)
  float.truncate(float.ceiling(after_discount))
}

pub fn days_in_budget(budget: Int, hourly_rate: Int, discount: Float) -> Float {
  let total_budget = int.to_float(budget)
  let discounted_rate = apply_discount(float.round(daily_rate(hourly_rate)), discount)

  float.floor(total_budget /. discounted_rate)
}
