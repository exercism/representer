defmodule FreelancerRates do
  import Float
  def daily_rate(hourly_rate) do
    # Please implement the daily_rate/1 function
    hourly_rate * 8.0
  end

  def apply_discount(before_discount, discount) do
    # Please implement the apply_discount/2 function
    before_discount - (discount / 100) * before_discount
  end

  def monthly_rate(hourly_rate, discount) do
    # Please implement the monthly_rate/2 function
    result = daily_rate(hourly_rate) * 22
    apply_discount(result, discount) |> Float.ceil |> trunc
  end

  def days_in_budget(budget, hourly_rate, discount) do
    # Please implement the days_in_budget/3 function
    daily_rate_result = daily_rate(hourly_rate)
    discounted_rate = apply_discount(daily_rate_result, discount)
    (budget / discounted_rate) |> Float.floor(1)
  end
end
