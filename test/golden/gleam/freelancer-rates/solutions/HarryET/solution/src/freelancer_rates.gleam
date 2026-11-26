import gleam/int
import gleam/float
import gleam/io

pub fn daily_rate(hourly_rate: Int) -> Float {
  int.to_float(hourly_rate * 8)
}

pub fn apply_discount(before_discount: Int, discount: Float) -> Float {
  let before_discount_float = int.to_float(before_discount)
  let fraction_multiplyer = discount /. int.to_float(100)
  let sub = float.multiply(before_discount_float, fraction_multiplyer)
  before_discount_float -. sub
}

pub fn monthly_rate(hourly_rate: Int, discount: Float) -> Int {
  float.round(float.ceiling(apply_discount(hourly_rate * 8 * 22, discount)))
}

pub fn days_in_budget(budget: Int, hourly_rate: Int, discount: Float) -> Float {
  let days = int.to_float(budget) /. int.to_float(hourly_rate * 8)
  let additional_days = float.multiply(days, { discount /. int.to_float(100) })
  float.ceiling(days +. additional_days)
}
