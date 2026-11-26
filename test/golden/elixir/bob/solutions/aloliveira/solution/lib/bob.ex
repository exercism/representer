defmodule Bob do
  # defguard is_yell(input) when String.match?

  @spec hey(String.t()) :: String.t()
  def hey(input) do
    input = String.trim(input)
    cond do
      input == "" -> "Fine. Be that way!"
      question?(input) and yell?(input) -> "Calm down, I know what I'm doing!"
      question?(input) -> "Sure."
      yell?(input) -> "Whoa, chill out!"
      true -> "Whatever."
    end
  end

  defp question?(input), do: String.match?(input, Regex.compile!("\\?$"))
  defp yell?(input), do: input == String.upcase(input) and input != String.downcase(input)
end
