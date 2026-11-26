defmodule AllYourBase do
  @doc """
  Given a number in input base, represented as a sequence of digits, converts it to output base,
  or returns an error tuple if either of the bases are less than 2
  """
  @spec convert(list, integer, integer) :: {:ok, list} | {:error, String.t()}
  def convert(_digits, input, _output) when input < 2, do: {:error, "input base must be >= 2"}
  def convert(_digits, _input, output) when output <= 2, do: {:error, "output base must be >= 2"}

  def convert(digits, input_base, output_base) do
    if Enum.any?(digits, fn x -> x < 0 or x >= input_base end),
      do: {:error, "all digits must be >= 0 and < input base"},
      else: {:ok, Integer.digits(Integer.undigits(digits, input_base), output_base)}
  end
end
