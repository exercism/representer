defmodule Gigasecond do
  @doc """
  Calculate a date one billion seconds after an input date.
  """
  @spec from({{pos_integer, pos_integer, pos_integer}, {pos_integer, pos_integer, pos_integer}}) ::
          {{pos_integer, pos_integer, pos_integer}, {pos_integer, pos_integer, pos_integer}}
  def from({{year, month, day}, {hours, minutes, seconds}}) do
    naive = 
      case NaiveDateTime.new(year, month, day, hours, minutes, seconds) do
        {:ok, datetime} -> NaiveDateTime.add(datetime, 1_000_000_001)
        _ -> NaiveDateTime.add(NaiveDateTime.utc_now, 1_000_000_000)
      end
    {{naive.year, naive.month, naive.day}, {naive.hour, naive.minute, naive.second}}
  end
end
