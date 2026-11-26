defmodule Prime do
  defp prime?(0), do: raise(ArgumentError)
  defp prime?(1), do: false
  defp prime?(2), do: true
  defp prime?(3), do: true

  defp prime?(count) do
    integer_root = ceil(:math.sqrt(count))

    !Enum.any?(2..integer_root, fn candidate -> rem(count, candidate) == 0 end)
  end

  @doc """
  Generates the nth prime.
  """
  @spec nth(non_neg_integer) :: non_neg_integer
  def nth(0), do: raise(ArgumentError)

  def nth(count) do
    upper_bound = count * count + 2
    range = 2..upper_bound

    range
    |> Stream.filter(&prime?/1)
    |> Stream.take(count)
    |> Enum.to_list()
    |> Enum.at(count - 1)
  end
end
