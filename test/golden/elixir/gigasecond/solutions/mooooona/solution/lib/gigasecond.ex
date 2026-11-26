defmodule Gigasecond do
  @doc """
  Calculate a date one billion seconds after an input date.
  """
  @spec from({{pos_integer, pos_integer, pos_integer}, {pos_integer, pos_integer, pos_integer}}) ::
          {{pos_integer, pos_integer, pos_integer}, {pos_integer, pos_integer, pos_integer}}
  def from(erlang_dt) do
    erlang_dt
    |> NaiveDateTime.from_erl!()
    |> NaiveDateTime.add(1000000000)
    |> NaiveDateTime.to_erl()
  end
end
