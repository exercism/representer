defmodule RotationalCipher do
  @doc """
  Given a plaintext and amount to shift by, return a rotated string.

  Example:
  iex> RotationalCipher.rotate("Attack at dawn", 13)
  "Nggnpx ng qnja"
  """
  @spec rotate(text :: String.t(), shift :: integer) :: String.t()
  def rotate(text, shift) when shift in [0, 26], do: text

  def rotate(text, shift) do
    <<text::binary>> = text

    text
    |> String.to_charlist()
    |> Enum.map(fn og -> slider(og, shift) end)
    |> List.to_string()
  end

  defp slider(og, shift) when og in ?a..?z do
    if og < ?z - shift + 1,
      do: og + shift,
      else: og + shift - 26
  end

  defp slider(og, shift) when og in ?A..?Z do
    if og < ?Z - shift + 1,
      do: og + shift,
      else: og + shift - 26
  end

  defp slider(og, _shift) do
    og
  end
end
