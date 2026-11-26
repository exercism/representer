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
    do_search(numbers, key, 0, tuple_size(numbers) - 1)
  end

  defp do_search(_numbers, _key, left, right) when left > right do
    :not_found
  end

  defp do_search(numbers, key, left, right) do
    middle = div(left + right, 2)
    middle_value = elem(numbers, middle)

    cond do
      middle_value == key -> {:ok, middle}
      middle_value > key -> do_search(numbers, key, left, middle - 1)
      middle_value < key -> do_search(numbers, key, middle + 1, right)
    end
  end
end
