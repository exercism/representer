defmodule BottleSong do
  @moduledoc """
  Handles lyrics of the popular children song: Ten Green Bottles
  """

  @lookup %{
    10 => "Ten",
    9 => "Nine",
    8 => "Eight",
    7 => "Seven",
    6 => "Six",
    5 => "Five",
    4 => "Four",
    3 => "Three",
    2 => "Two"
  }

  @fall "And if one green bottle should accidentally fall,\n"

  defp hanging(1), do: "One green bottle hanging on the wall,\n"

  defp hanging(num), do: "#{@lookup[num]} green bottles hanging on the wall,\n"

  defp left(2),
    do: "There'll be one green bottle hanging on the wall."

  defp left(1),
    do: "There'll be no green bottles hanging on the wall."

  defp left(num),
    do: "There'll be #{@lookup[num - 1] |> String.downcase()} green bottles hanging on the wall."

  defp form_verse(start_bottle) do
    hang = hanging(start_bottle)
    "#{hang}#{hang}#{@fall}#{left(start_bottle)}"
  end

  defp do_form_verses(start_bottle, 1, agg), do: agg <> form_verse(start_bottle)

  defp do_form_verses(start_bottle, take_down, agg) do
    cur = form_verse(start_bottle)
    do_form_verses(start_bottle - 1, take_down - 1, agg <> cur <> "\n\n")
  end

  @spec recite(pos_integer, pos_integer) :: String.t()
  def recite(start_bottle, take_down) do
    do_form_verses(start_bottle, take_down, "")
  end
end
