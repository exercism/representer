defmodule IsbnVerifier do
  @doc """
    Checks if a string is a valid ISBN-10 identifier

    ## Examples

      iex> IsbnVerifier.isbn?("3-598-21507-X")
      true

      iex> IsbnVerifier.isbn?("3-598-2K507-0")
      false

  """
  @spec isbn?(String.t()) :: boolean
  def isbn?(isbn) do
    with no_hyphens when bit_size(no_hyphens) === 10 * 8 <- String.replace(isbn, ~r/-/, ""),
         no_invalid_chars when bit_size(no_invalid_chars) === 10 * 8 <- String.replace(no_hyphens, ~r/[A-WYZ]/, ""),
         true <- String.contains?(no_invalid_chars, "X") === false or (String.contains?(no_invalid_chars, "X") and String.match?(no_invalid_chars, ~r/X$/)),
         true <- valid_digits?(no_invalid_chars)
    do
      true
    else
      _ -> false
    end
  end

  defp valid_digits?(isbn, i \\ 0, acc \\ 0)
  defp valid_digits?(isbn, 9, acc) do
    case String.at(isbn, 9) do
      "X" -> Integer.mod(acc + 10, 11) === 0
      str -> Integer.parse(str) |> (fn {n, _} -> Integer.mod(acc + n, 11) === 0 end).()
    end
  end
  defp valid_digits?(isbn, i, acc) do
    String.at(isbn, i)
    |> Integer.parse()
    |> (fn {n, _} -> valid_digits?(isbn, i + 1, acc + n * (10 - i)) end).()
  end
end
