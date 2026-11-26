defmodule Acronym do
  @symbols ~r/[[:punct:]]/
  @doc """
  Generate an acronym from a string.
  "This is a string" => "TIAS"
  """
  @spec abbreviate(String.t()) :: String.t()
  def abbreviate(string) do
    string
    |> String.split(~r/[\s|-]+/)
    |> Enum.map(fn x -> String.replace(x, @symbols, "") end)
    |> Enum.map(&String.first/1)
    |> Enum.map(&String.upcase/1)
    |> Enum.join("")
  end
end
