defmodule Diamond do
  @doc """
  Given a letter, it prints a diamond starting with 'A',
  with the supplied letter at the widest point.
  """
  @spec build_shape(char) :: String.t()
  def build_shape(letter) do
    letter
    |> sequence()
    |> Enum.map_join("\n", &build_line(&1, letter))
    |> Kernel.<>("\n")
  end

  defp sequence(letter) do
    Enum.to_list(?A..letter) ++ tl(Enum.to_list(letter..?A))
  end

  defp build_line(letter, base) do
    last = (base - ?A) * 2
    0..last
    |> Enum.map(fn el ->
      cond do
        el == base - letter -> letter
        el == last - (base - letter) -> letter
        true -> ?\s
      end
    end)
  end
end
