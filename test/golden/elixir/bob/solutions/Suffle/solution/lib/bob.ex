defmodule Bob do
  @spec question?(String.t()) :: boolean()
  def question?(input), do: String.last(String.trim(input)) === "?"

  @spec upper?(String.t()) :: boolean()
  def upper?(input) when is_binary(input), do: String.downcase(input) !== input && String.upcase(input) === input

  @spec hey(String.t()) :: String.t()
  def hey(input) when is_binary(input) do
    cond do
      String.trim(input) === "" -> "Fine. Be that way!"
      question?(input) && upper?(input) -> "Calm down, I know what I'm doing!"
      question?(input) -> "Sure."
      upper?(input) -> "Whoa, chill out!"
      true -> "Whatever."
    end
  end
  def hey(_), do: "Fine. Be that way!"
end
