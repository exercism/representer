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
    search(numbers, key, 0, tuple_size(numbers))
  end

  defp search({}, _, _, _) do
    :not_found
  end

  defp search(_, _, x, x) do
    :not_found
  end

  defp search(numbers, key, low, high) do
    index = div(low + high, 2)
    number = elem(numbers, index)

    cond do
      number == key ->
        {:ok, index}

      number > key ->
        search(numbers, key, 0, index)

      number < key ->
        search(numbers, key, index + 1, high)
    end
  end
end
