defmodule Bob do
  @spec hey(String.t()) :: String.t()
  def hey(input) do
    cond do
      !(input =~ ~r/[^\s]+/) -> "Fine. Be that way!"
      input == String.upcase(input) or input =~ ~r/[A-Z]+/ and "?" == String.last(input) -> "Calm down, I know what I'm doing!"
      input =~ ~r/\?[\s]*$/ -> "Sure."
      input == String.upcase(input) and input =~ ~r/[^\d\W]+/ -> "Whoa, chill out!"
      true -> "Whatever."
    end
  end
end
