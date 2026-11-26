defmodule LibraryFees do
  def datetime_from_string(string) do
    {:ok, result} = NaiveDateTime.from_iso8601(string)
    result
  end

  def before_noon?(datetime) do
    result = datetime
    |> NaiveDateTime.to_time()
    |> Time.compare(Time.new!(12, 0, 0, 0))
    result === :lt
  end

  def return_date(checkout_datetime) do
    to_add = if (before_noon?(checkout_datetime)), do: 28, else: 29
    checkout_datetime
    |> NaiveDateTime.to_date()
    |> Date.add(to_add)
  end

  def days_late(planned_return_date, actual_return_datetime) do
    diff = Date.diff(actual_return_datetime, planned_return_date)
    if (diff < 0), do: 0, else: diff
  end

  def monday?(datetime) do
    day = datetime
    |> NaiveDateTime.to_date()
    |> Date.day_of_week()
    day === 1
  end

  def calculate_late_fee(checkout, return, rate) do
    fee = days_late(return_date(datetime_from_string(checkout)), datetime_from_string(return)) * rate
    if (monday?(datetime_from_string(return))), do: div(fee, 2), else: fee
  end
end
