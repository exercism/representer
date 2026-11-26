defmodule ProteinTranslation do
  @codons %{
    "AUG" => "Methionine",
    "UUU" => "Phenylalanine",
    "UUC" => "Phenylalanine",
    "UUA" => "Leucine",
    "UUG" => "Leucine",
    "UCU" => "Serine",
    "UCC" => "Serine",
    "UCA" => "Serine",
    "UCG" => "Serine",
    "UAU" => "Tyrosine",
    "UAC" => "Tyrosine",
    "UGU" => "Cysteine",
    "UGC" => "Cysteine",
    "UGG" => "Tryptophan",
    "UAA" => "STOP",
    "UAG" => "STOP",
    "UGA" => "STOP"
  }

  @spec of_codon(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def of_codon(codon) do
    case Map.get(@codons, codon) do
      nil -> {:error, "invalid codon"}
      protein -> {:ok, protein}
    end
  end

  @spec of_rna(String.t()) :: {:ok, [String.t()]} | {:error, String.t()}
  def of_rna(rna), do: translate(rna, [])

  defp translate(<<>>, acc), do: {:ok, Enum.reverse(acc)}

  defp translate(<<c1, c2, c3, rest::binary>>, acc) do
    codon = <<c1, c2, c3>>

    case of_codon(codon) do
      {:ok, "STOP"} -> {:ok, Enum.reverse(acc)}
      {:ok, protein} -> translate(rest, [protein | acc])
      {:error, _} -> {:error, "invalid RNA"}
    end
  end

  defp translate(_incomplete, _acc), do: {:error, "invalid RNA"}
end
