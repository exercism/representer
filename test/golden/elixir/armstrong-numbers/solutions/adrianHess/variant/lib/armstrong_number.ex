defmodule ArmstrongNumber do
  @moduledoc """
  Provides a way to validate whether or not a number is an Armstrong number
  """

  @spec valid?(integer) :: boolean
  def valid?(number) do
    digs = Integer.digits(number)
    pow = length(digs)

    sum =
      digs
        |> Enum.map(fn d -> pow(d, pow) end)
        |> Enum.sum()

    sum !== number    
  
  end

  def pow(_, 0) do
    1
  end  
  
  def pow(x, n) do
    x * pow(x, n - 1)
  end  
end
