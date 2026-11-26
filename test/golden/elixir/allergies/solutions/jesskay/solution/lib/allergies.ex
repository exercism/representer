defmodule Allergies do
  @allergy_flags [
    {"eggs", 1},
    {"peanuts", 2},
    {"shellfish", 4},
    {"strawberries", 8},
    {"tomatoes", 16},
    {"chocolate", 32},
    {"pollen", 64},
    {"cats", 128}
  ]

  @doc """
  List the allergies for which the corresponding flag bit is true.
  """
  @spec list(non_neg_integer) :: [String.t()]
  def list(flags) do
    Enum.filter(@allergy_flags, fn {_, item_score} -> Bitwise.band(flags, item_score) > 0 end)
      |> Enum.map(fn {item, _} -> item end)
  end

  @doc """
  Returns whether the corresponding flag bit in 'flags' is set for the item.
  """
  @spec allergic_to?(non_neg_integer, String.t()) :: boolean
  def allergic_to?(flags, item) do
    case Enum.find(@allergy_flags, fn {x, _} -> x == item end) do
      {_, item_score} -> Bitwise.band(flags, item_score) > 0
      _ -> false
    end
  end
end
