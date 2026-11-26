defmodule MatchingBrackets do
  @doc """
  Checks that all the brackets and braces in the string are matched correctly, and nested correctly
  """
  @spec check_brackets(String.t()) :: boolean
  def check_brackets(str) do
    String.codepoints(str)
    |> check_brackets_util()
  end

  def check_brackets_util(list, counters \\ [])
  def check_brackets_util([], counters), do: Enum.count(counters) == 0

  def check_brackets_util([h|tail], counters) do
    case h do
      "{" -> push(counters, "{")
      "}" -> pop(counters, "{")
      "[" -> push(counters, "[")
      "]" -> pop(counters, "[")
      "(" -> push(counters, "(")
      ")" -> pop(counters, "(")
      _ -> {:ok, counters}
    end
    |> case do
      {:error, _} -> false
      {:ok, updated} -> check_brackets_util(tail, updated)
    end
  end

  def push(list, i), do: {:ok, [i | list]}
  def pop([], _), do: {:error, []}
  def pop([h | t], i) do
    case h == i do
      true -> {:ok, t}
      _ -> {:error, t}
    end
  end
end
