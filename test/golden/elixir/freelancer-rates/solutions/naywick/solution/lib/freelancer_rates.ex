defmodule FreelancerRates do
  def daily_rate(hourly_rate) do
    (8 * hourly_rate) / 1
  end

  def apply_discount(before_discount, discount) do
    before_discount - (before_discount * (discount/100))
  end

  def monthly_rate(hourly_rate, discount) do
    monthly_rate = ((8 * hourly_rate) * 22)
    ceil(apply_discount(monthly_rate, discount))
  end

  def days_in_budget(budget, hourly_rate, discount) do
    daily = daily_rate(hourly_rate) # cost per day
    discounted_daily = apply_discount(daily, discount) # cost per day with discount
    Float.floor(budget / discounted_daily, 1)
  end
end
