defmodule FreelancerRates do
  def daily_rate(hourly_rate) do
    hourly_rate * 8.0
  end

  def apply_discount(before_discount, discount) do
    before_discount * (100.0 - discount)/100.0
  end

  def monthly_rate(hourly_rate, discount) do
    daily_to_monthly = fn rate -> rate * 22.0 end

    hourly_rate
    |> daily_rate()
    |> daily_to_monthly.()
    |> apply_discount(discount)
    |> ceil()
  end

  def days_in_budget(budget, hourly_rate, discount) do
    daily_rate_discounted = hourly_rate
                            |> daily_rate()
                            |> apply_discount(discount)

    Float.floor(budget / daily_rate_discounted, 1)
  end
end
