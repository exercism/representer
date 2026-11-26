defmodule BinarySearch do
  @doc """
  Searches for a key in the tuple using the binary search algorithm.
  It returns :not_found if the key is not in the tuple.
  Otherwise returns {:ok, index}.

  ## Examples

    iex> BinarySearch.search({}, 2)
    :not_found

    iex> BinarySearch.search({1, 3, 5}, 2)
    :not_found

    iex> BinarySearch.search({1, 3, 5}, 5)
    {:ok, 2}

  """

  @spec search(tuple, integer) :: {:ok, integer} | :not_found
  def search(numbers, key) do
    search_do(numbers, key, 0, tuple_size(numbers) - 1)
  end

  defp search_do(_numbers, _key, min, max) when min > max do
    :not_found
  end

  defp search_do(numbers, key, min, max) do
    n = div(min + max, 2)
    mid = elem(numbers, n)

    cond do
      mid == key -> {:ok, n}
      mid > key -> search_do(numbers, key, min, n - 1)
      mid < key -> search_do(numbers, key, n + 1, max)
    end
  end
end
