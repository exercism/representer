defmodule BinarySearch do
  @doc """
    Searches for a key in a sorted tuple using the binary search algorithm.
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
  def search({}, _), do: :not_found

  def search({n}, key) when n != key, do: :not_found

  def search({n}, key) when n == key, do: {:ok, 0}

  def search(tuple, key) do
    search_helper(tuple, key, 0, tuple_size(tuple) - 1)
  end

  defp search_helper(_, _, low, high) when low > high do 
    :not_found
  end

  defp search_helper(tuple, key, low, high) do
    mid = div(low + high, 2)
    mid_val = elem(tuple, mid)

    cond do
      mid_val == key -> {:ok, mid}
      mid_val < key -> search_helper(tuple, key, mid + 1, high)
      true -> search_helper(tuple, key, low, mid - 1)
    end
  end
end
