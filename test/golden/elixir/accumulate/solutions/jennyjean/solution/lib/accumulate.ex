defmodule Accumulate do
  @doc """
    Given a list and a function, apply the function to each list item and
    replace it with the function's return value.

    Returns a list.

    ## Examples

      iex> Accumulate.accumulate([], fn(x) -> x * 2 end)
      []

      iex> Accumulate.accumulate([1, 2, 3], fn(x) -> x * 2 end)
      [2, 4, 6]

  """

  @spec accumulate(list, (any -> any)) :: list
  def accumulate(list, fun) do
    accumulate(list, fun, [])
  end

  defp accumulate([], _fun, updated_list), do: Enum.reverse(updated_list)

  defp accumulate(list, fun, updated_list) do
    {first_el, remaining_list} = List.pop_at(list, 0)
    accumulate(remaining_list, fun, [ fun.(first_el) | updated_list ])
  end
end

Accumulate.accumulate([1,2,3], fn n -> n * n end)
|> IO.inspect()
