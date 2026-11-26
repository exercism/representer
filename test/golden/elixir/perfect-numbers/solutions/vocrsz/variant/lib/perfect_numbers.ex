defmodule PerfectNumbers do
  @doc """
  Determine the aliquot sum of the given `number`, by summing all the factors
  of `number`, aside from `number` itself.

  Based on this sum, classify the number as:

  :perfect if the aliquot sum is equal to `number`
  :abundant if the aliquot sum is greater than `number`
  :deficient if the aliquot sum is less than `number`
  """
  @spec classify(number :: integer) :: {:ok, atom} | {:error, String.t()}
  def classify(n) when n < 1, do:  {:error, "Classification is only possible for natural numbers."}
  def classify(number) do
    sum = (1..round(:math.sqrt(number)))
    |> Enum.filter(fn n -> rem(number, n) == 0 end)
    |> Enum.flat_map(fn m -> if (div(number, m) == m), do: [m], else: [m, div(number, m)] end)
    |> Enum.sum()
    |> then(&(&1 + number))
    |> dbg()

    cond do
      sum > number -> {:ok, :abundant}
      sum < number -> {:ok, :deficient}
      true -> {:ok, :perfect}
    end
  end
end
