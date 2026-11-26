defmodule Proverb do
  @doc """
  Generate a proverb from a list of strings.
  """
  @spec recite(strings :: [String.t()]) :: String.t()
  def recite([]), do: ""

  def recite([h | _t] = list) do
    recite_line(list, "") <> "And all for the want of a #{h}.\n"
  end

  def recite_line([_h | []], acc), do: acc

  def recite_line([h | [t_h | _] = t], acc) do
    recite_line(t, acc <> "For want of a #{h} the #{t_h} was lost.\n")
  end
end
