defmodule Meetup do
  @moduledoc """
  Calculate meetup dates.
  """

  @type weekday ::
          :monday
          | :tuesday
          | :wednesday
          | :thursday
          | :friday
          | :saturday
          | :sunday

  @type schedule :: :first | :second | :third | :fourth | :last | :teenth

  @doc """
  Calculate a meetup date.

  The schedule is in which week (1..4, last or "teenth") the meetup date should
  fall.
  """
  @spec meetup(pos_integer, pos_integer, weekday, schedule) :: Date.t()
  def meetup(year, month, weekday, schedule) do
    first_of_month = Date.from_erl!({year, month, 1})
    first_of_week = Date.beginning_of_week(first_of_month)
    month_starts_on = Date.diff(first_of_month, first_of_week)
    target_day = numerical_day(weekday)
    target_week = numerical_schedule(schedule)
    target_week =
      cond do
        target_week > 4 -> target_week
        target_day < month_starts_on -> target_week
        true -> target_week - 1
      end
    cond do
      target_week < 6 ->
        Date.shift(first_of_week, day: 7 * target_week + target_day)
      target_week < 10 ->
        if 35 + target_day - month_starts_on >= Date.days_in_month(first_of_month) do
          if 28 + target_day - month_starts_on >= Date.days_in_month(first_of_month) do
            Date.shift(first_of_week, day: 21 + target_day)
          else
            Date.shift(first_of_week, day: 28 + target_day)
          end
        else
          Date.shift(first_of_week, day: 35 + target_day)
        end
      true ->
        teenth(first_of_month, target_day, 12)
    end
  end

  defp teenth(_first_of_month, _target_day, 20), do: raise "error"
  defp teenth(first_of_month, target_day, offset) do
    test_date = Date.shift(first_of_month, day: offset)
    if Date.day_of_week(test_date) == target_day + 1 do
      test_date
    else
      teenth(first_of_month, target_day, offset + 1)
    end
  end
  
  defp numerical_day(:monday), do: 0
  defp numerical_day(:tuesday), do: 1
  defp numerical_day(:wednesday), do: 2
  defp numerical_day(:thursday), do: 3
  defp numerical_day(:friday), do: 4
  defp numerical_day(:saturday), do: 5
  defp numerical_day(:sunday), do: 6

  defp numerical_schedule(:first), do: 1
  defp numerical_schedule(:second), do: 2
  defp numerical_schedule(:third), do: 3
  defp numerical_schedule(:fourth), do: 4
  defp numerical_schedule(:last), do: 6
  defp numerical_schedule(:teenth), do: 10
end
