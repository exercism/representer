defmodule FlattenArray do
  @doc """
    Accept a list and return the list flattened without nil values.

    ## Examples

      iex> FlattenArray.flatten([1, [2], 3, nil])
      [1, 2, 3]

      iex> FlattenArray.flatten([nil, nil])
      []

  """

  @spec flatten(list) :: list
  def flatten(list) do
    reverse(flatten(list, []))
  end

  defp flatten([], arr), do: arr
  defp flatten([a], arr), do: insert(a, arr)
  defp flatten([head | tail], arr), do: flatten(tail, insert(head, arr))
  defp insert(nil, arr), do: arr
  defp insert([], arr), do: arr
  defp insert([a], arr), do: insert(a, arr)
  defp insert([head | tail], arr) do
    flatten(tail, insert(head, arr))
  end
  defp insert(a, arr), do: [a | arr]

  defp reverse(list) do
    reverse(list, [])
  end

  defp reverse([], arr), do: arr
  defp reverse([a], arr), do: [a | arr]
  defp reverse([head | tail], arr), do: reverse(tail, [head | arr])
end
