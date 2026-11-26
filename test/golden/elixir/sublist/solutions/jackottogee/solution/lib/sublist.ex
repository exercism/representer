defmodule Sublist do
  @doc """
  Returns whether the first list is a sublist or a superlist of the second list
  and if not whether it is equal or unequal to the second list.
  """
  def compare(a, a), do: :equal
  def compare(a,b) do
    cond do
      (sublist?(a, b, length(a), length(b))) -> :sublist
      (sublist?(b, a, length(b), length(a))) -> :superlist
      true -> :unequal
    end
  end

  defp sublist?([], _, _, _), do: true
  defp sublist?(a, b, length_a, length_b) do
    cond do
      (length_a > length_b) -> false
      (a === Enum.take(b, length_a)) -> true
      true -> sublist?(a, tl(b), length_a, length_b - 1)
    end
  end
end
