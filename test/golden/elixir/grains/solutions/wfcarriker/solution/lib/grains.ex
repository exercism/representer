defmodule Grains do
  @doc """
  Calculate two to the power of the input minus one.
  """
  @spec square(pos_integer()) :: {:ok, pos_integer()} | {:error, String.t()}
  def square(number) when number < 1 or number > 64, do: {:error, "The requested square must be between 1 and 64 (inclusive)"}
  def square(1), do: {:ok, 1}
  def square(number) do
    square = Enum.reduce(2..number, 1, fn _, square -> square * 2 end)
    {:ok, square}
  end
  
  @doc """
  Adds square of each number from 1 to 64.
  """
  @spec total :: {:ok, pos_integer()}
  def total do
    {_, total} = Enum.reduce(2..64, {1, 1}, fn _, {square, total} -> {square * 2, total + square * 2} end)
    {:ok, total}
  end
end
