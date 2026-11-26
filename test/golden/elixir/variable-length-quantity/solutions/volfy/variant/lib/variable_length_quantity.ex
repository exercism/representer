defmodule VariableLengthQuantity do
  use Bitwise

  @doc """
  Encode integers into a bitstring of VLQ encoded bytes
  """
  @spec encode(integers :: [integer]) :: binary
  def encode(integers) when is_list(integers) do
    integers
    |> Enum.map(&do_encode*1)
    |> Enum.map(&reverse_bs/1)
    |> Enum.join(<<>>)
  end

  @spec do_encode(num: pos_integer()) :: bitstring()
  defp do_encode(num)

  defp do_encode(0), do: <<0>>

  defp do_encode(n, leading \\ 0)
  defp do_encode(0, _), do: <<>>

  defp do_encode(n, leading) do
    rest = Bitwise.bsr(n, 7)

    <<leading::1, n::7, do_encode(rest, 1)::binary>>
  end

  @doc """
  Decode a bitstring of VLQ encoded bytes into a series of integers
  """
  @spec decode(bytes :: binary) :: {:ok, [integer]} | {:error, String.t()}
  def decode(bytes) do
    do_decode(bytes)
  end

  defp do_decode(bytes, status \\ :complete, acc \\ 0)

  defp do_decode(<<>>, :complete, _), do: {:ok, []}
  defp do_decode(<<>>, :pending, _), do: {:error, "incomplete sequence"}

  defp do_decode(<<leading::1, byte::7, rest::binary>>, _, acc) do
    acc = Bitwise.bsl(acc, 7) + byte

    if leading == 1 do
      do_decode(rest, :pending, acc)
    else
      with {:ok, result} <- do_decode(rest, :complete) do
        {:ok, [acc | result]}
      end
    end
  end

  defp reverse_bs(bs) do
    list = for <<x <- bs>>, do: x
    for bit <- Enum.reverse(list), into: <<>>, do: <<bit>>
  end
end
