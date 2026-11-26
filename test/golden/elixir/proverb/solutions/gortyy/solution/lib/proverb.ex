defmodule Proverb do
  @doc """
  Generate a proverb from a list of strings.
  """
  @spec recite(strings :: [String.t()]) :: String.t()
  def recite([]), do: ""

  def recite(strings) do
    chunks = chunk(strings)

    chunks
    |> Enum.reduce("", fn [w1, w2], acc ->
      acc <> "For want of a #{w1} the #{w2} was lost.\n"
    end)
    |> Kernel.<>("And all for the want of a #{hd(strings)}.\n")
  end

  defp chunk(strings) do
    strings
    |> Enum.chunk_every(2, 1)
    |> Enum.reverse()
    |> tl()
    |> Enum.reverse()
  end
end
