# My attempt
#defmodule MatchingBrackets do
#  @doc """
#  Checks that all the brackets and braces in the string are matched correctly, and nested correctly
#  """
#  @spec check_brackets(String.t()) :: boolean
#  def check_brackets(str) do
#    c = str
#    |> String.replace(~r/[^\[\]\(\)\{\}]/, "")
#    |> String.graphemes()
#    |> Enum.frequencies()
#
#    c["("] == c[")"] and c["["] == c["]"] and c["{"] == c["}"]
#  end
#end

# Not my solution
defmodule MatchingBrackets do
  @doc """
  Checks that all the brackets and braces in the string are matched correctly, and nested correctly
  """
  @spec check_brackets(String.t()) :: boolean
  def check_brackets(str) do
    str
    |> String.replace(~r/[^\[\]\{\}\(\)]/, "")
    |> check
  end

  defp check(str, prev \\ "")
  defp check("", _), do: true
  defp check(str, prev) when str == prev, do: false

  defp check(str, _) do
    check(
      str
      |> String.split(~r/(\(\))|(\[\])|(\{\})/)
      |> Enum.join(),
      str
    )
  end
end
