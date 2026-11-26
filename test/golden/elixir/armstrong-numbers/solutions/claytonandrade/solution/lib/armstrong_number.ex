defmodule ArmstrongNumber do
  @moduledoc """
  Provides a way to validate whether or not a number is an Armstrong number
  """

  @spec valid?(integer) :: boolean
  def valid?(number) do
    digits = number |> Integer.digits()
    exp = digits |> length()
    number == Enum.reduce(digits, 0, &(Integer.pow(&1, exp) + &2))
  end
end
