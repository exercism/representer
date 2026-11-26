defmodule RunLengthEncoder do

  defp to_number([]), do: 1
  defp to_number(digits) do
    digits
    |> Enum.with_index
    |> Enum.reduce(0, fn({n, i}, acc) -> acc + n * (10 ** i) end)
    |> trunc
  end

  defp do_encode(<< code, code, string::binary>>, count, acc) do
    do_encode(<<code, string::binary>>, count + 1, acc)
  end
  defp do_encode(<< code, next, string::binary>>, 1, acc) do
    do_encode(<< next, string::binary>>, 1, acc <> "#{<<code>>}")
  end
  defp do_encode(<< code, next, string::binary>>, count, acc) do
    do_encode(<< next, string::binary>>, 1, acc <> "#{count}#{<<code>>}")
  end
  defp do_encode(<<_>> = char, 1, acc), do: acc <> "#{char}"
  defp do_encode(<<_>> = char, count, acc), do: acc <> "#{count}#{char}"
  defp do_encode("", _, acc), do: acc <> ""


  defp do_decode(<<n, string::binary>>, digits, acc) when n in 49..57 do
    do_decode(string,[n - 48 | digits], acc)
  end
  defp do_decode(<<code, string::binary>>, digits, acc) do
    do_decode(string, [], acc <> String.duplicate(<<code>>, to_number(digits)))
  end
  defp do_decode("", _, acc), do: acc

  @doc """
  Generates a string where consecutive elements are represented as a data value and count.
  "AABBBCCCC" => "2A3B4C"
  For this example, assume all input are strings, that are all uppercase letters.
  It should also be able to reconstruct the data into its original form.
  "2A3B4C" => "AABBBCCCC"
  """
  @spec encode(String.t()) :: String.t()
  def encode(string), do: do_encode(string, 1, "")

  @spec decode(String.t()) :: String.t()
  def decode(string), do: do_decode(string, [], "")
end
