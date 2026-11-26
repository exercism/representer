defmodule FreelancerRates do
  def daily_rate(hourly_rate) do
    # Please implement the daily_rate/1 function
    hourly_rate*8.0
  end

  def apply_discount(before_discount, discount) do
    # Please implement the apply_discount/2 function
    discount_amount=before_discount*(discount/100)
    before_discount-discount_amount
  end

  def monthly_rate(hourly_rate, discount) do
    # Please implement the monthly_rate/2 function
    monthly_rate_before_discount=daily_rate(hourly_rate)*22.0
    ceil(apply_discount(monthly_rate_before_discount,discount))
  end

  def days_in_budget(budget, hourly_rate, discount) do
    # Please implement the days_in_budget/3 function
    daily_rate_=daily_rate(hourly_rate)
    discounted_daily_rate=apply_discount(daily_rate_, discount)
    Float.floor(budget/discounted_daily_rate,1)
  end
end
