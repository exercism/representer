defmodule Atbash do
  @keylist Enum.zip(
             Enum.to_list(?0..?9) ++ Enum.to_list(?a..?z),
             Enum.to_list(?0..?9) ++ Enum.to_list(?z..?a)
           )

  @doc """
  Encode a given plaintext to the corresponding ciphertext

  ## Examples

  iex> Atbash.encode("completely insecure")
  "xlnko vgvob rmhvx fiv"
  """
  @spec encode(String.t()) :: String.t()
  def encode(plaintext) do
    plaintext
    |> String.replace(~r/\W/, "")
    |> String.downcase()
    |> to_charlist()
    |> Enum.map(fn ch ->
      List.keyfind(@keylist, ch, 0) |> elem(1)
    end)
    |> Enum.chunk_every(5)
    |> Enum.join(" ")
  end

  @spec decode(String.t()) :: String.t()
  def decode(cipher) do
    cipher
    |> String.replace(~r/\s/, "")
    |> to_charlist()
    |> Enum.map(fn ch ->
      List.keyfind(@keylist, ch, 1) |> elem(0)
    end)
    |> to_string()
  end
end
