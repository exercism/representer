defmodule ArmstrongNumber do
  @moduledoc """
  Provides a way to validate whether or not a number is an Armstrong number
  """

  @spec valid?(integer) :: boolean
  def valid?(number) do
    list = Integer.digits(number)
    pow = length(list)
    number ==
      Enum.reduce(list, 0, fn x, acc ->
        acc + Integer.pow(x, pow)
      end)
  end
end
