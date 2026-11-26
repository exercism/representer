defmodule Change do
  @doc """
    Determine the least number of coins to be given to the user such
    that the sum of the coins' value would equal the correct amount of change.
    It returns {:error, "cannot change"} if it is not possible to compute the
    right amount of coins. Otherwise returns the tuple {:ok, list_of_coins}

    ## Examples

      iex> Change.generate([5, 10, 15], 3)
      {:error, "cannot change"}

      iex> Change.generate([1, 5, 10], 18)
      {:ok, [1, 1, 1, 5, 10]}

  """

  @spec generate(list, integer) :: {:ok, list} | {:error, String.t()}
  def generate(_, 0), do: {:ok, []}
  def generate(_, target) when target < 0, do: {:error, "cannot change"}
  def generate([], _), do: {:error, "cannot change"}
  def generate([only_coin | []], target) do
    if rem(target, only_coin) == 0 do
      List.duplicate(only_coin, div(target, only_coin))
    else
      {:error, "cannot change"}
    end
  end
  def generate(coins, target) do
    valid = Enum.sort(coins)
    |> Enum.filter(&(&1 <= target))

    if valid == [] do 
      {:error, "cannot change"} 
    else
    
      biggest_coin = List.last(valid)
      big_tail_amount = target - biggest_coin * 2
      big_tail = big_tail_amount > 0 && List.duplicate(biggest_coin, div(big_tail_amount, biggest_coin)) || []
      
      rest_target = target - (biggest_coin * Enum.count(big_tail))
      
      if rest_target > 0 do
        {res, value} = do_generate(Enum.reverse(valid), rest_target, [], {:error, "cannot change"})
        if res == :ok, do: {:ok, value ++ big_tail}, else: {:error, "cannot change"}
      else
        {:ok, big_tail}
      end
    end
  end


  defp do_generate(_, _, current, {:ok, best}) when length(current) >= length(best) do
    {:ok, best}
  end
  defp do_generate(_, 0, current, _), do: {:ok, current}
  defp do_generate([], _, _, best), do: best
  defp do_generate([coin | coins], target, current, best) when coin > target do
    do_generate(coins, target, current, best)
  end
  defp do_generate([coin | coins], target, current, best) do
    first_try = do_generate([coin | coins], target - coin, [coin | current], best)
    do_generate(coins, target, current, first_try)
  end
end
