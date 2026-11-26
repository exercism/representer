defmodule FreelancerRates do
  def daily_rate(hourly_rate) do
    # Please implement the daily_rate/1 function
    hourly_rate * 8.0
  end

  def apply_discount(before_discount, discount) do
    # Please implement the apply_discount/2 function
    before_discount - ((discount/100.0) * before_discount)
  end

  def monthly_rate(hourly_rate, discount) do
    # Please implement the monthly_rate/2 function
  	ceil((hourly_rate * 8 * 22) - (discount/100) * (hourly_rate * 8 * 22))
  end

  def days_in_budget(budget, hourly_rate, discount) do
    # Please implement the days_in_budget/3 function
    Float.floor((budget / floor((hourly_rate * 8) - (discount/100) * (hourly_rate * 8))), 1)
  end
end
