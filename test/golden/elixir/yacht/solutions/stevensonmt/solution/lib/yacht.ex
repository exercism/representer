defmodule Yacht do
  @type category ::
          :ones
          | :twos
          | :threes
          | :fours
          | :fives
          | :sixes
          | :full_house
          | :four_of_a_kind
          | :little_straight
          | :big_straight
          | :choice
          | :yacht

  

  def score_sets(i, dice), do: Enum.frequencies(dice) |> Map.get(i, 0) |> Kernel.*(i)
  def score_four_of_a_kind(dice) do 
    dice 
    |> Enum.frequencies() 
    |> Enum.filter(fn {_k, v} -> v >= 4 end) 
    |> Enum.reduce(0, fn {k, v}, acc -> (k * 4) + acc end)
  end

  defp scorer() do
    %{ 
            ones: fn dice -> Yacht.score_sets(1, dice) end,
            twos: fn dice -> Yacht.score_sets(2, dice) end,
            threes: fn dice -> Yacht.score_sets(3, dice) end,
            fours: fn dice -> Yacht.score_sets(4, dice) end,
            fives: fn dice -> Yacht.score_sets(5, dice) end,
            sixes: fn dice -> Yacht.score_sets(6, dice) end,
            full_house: fn dice -> Enum.sum(dice) end,
            four_of_a_kind: fn dice -> Yacht.score_four_of_a_kind(dice) end,
            little_straight: fn _ -> 30 end,
            big_straight: fn _ -> 30 end,
            choice: fn dice -> Enum.sum(dice) end,
            yacht: fn _ -> 50 end
    }
  end

  @doc """
  Calculate the score of 5 dice using the given category's scoring method.
  """
  @spec score(category :: category(), dice :: [integer]) :: integer
  def score(category, dice) do
    if valid_for_category?(category, Enum.sort(dice)) do
      f = Map.get(scorer(), category)
      f.(dice)
    else
      0
    end        
  end

  defp valid_for_category?(category, dice) do 
    case category do 
      :full_house -> Enum.frequencies(dice) |> Map.values() |> Enum.sort() |> Kernel.==([2,3])
      :four_of_a_kind -> Enum.frequencies(dice) |> Map.values() |> Enum.any?(&Kernel.>=(&1, 4))
      :little_straight -> dice == [1,2,3,4,5]
      :big_straight -> dice == [2,3,4,5,6]
      :yacht -> Enum.uniq(dice) |> Enum.count() == 1
      _ -> true
    end
  end
end
