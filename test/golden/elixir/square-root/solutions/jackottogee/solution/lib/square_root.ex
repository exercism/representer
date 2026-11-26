defmodule SquareRoot do
  @doc """
  Calculate the integer square root of a positive integer
  """
  @spec calculate(radicand :: pos_integer) :: pos_integer
  def calculate(radicand, estimate \\ nil) 
  def calculate(radicand, estimate) when estimate == nil, do: calculate(radicand, radicand)
  def calculate(radicand, estimate) when abs(estimate * estimate - radicand) < 0.0000001, do: round(estimate)
  def calculate(radicand, estimate), do: calculate(radicand, 0.5 * (estimate + (radicand / estimate)))

  
end
