defmodule ArmstrongNumber do
  @moduledoc """
  Provides a way to validate whether or not a number is an Armstrong number
  """

  @spec valid?(integer) :: boolean
  def valid?(number) do
    digits = number |> Integer.digits()
    formated_number =
      digits
      |> Enum.reduce(0, fn digit, acc -> acc + Integer.pow(digit, length(digits))  end)

    formated_number == number
  end
end
