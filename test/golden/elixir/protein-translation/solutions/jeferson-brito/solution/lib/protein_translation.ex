defmodule ProteinTranslation do
  @doc """
  Given an RNA string, return a list of proteins specified by codons, in order.
  """
  @spec of_rna(String.t()) :: {:ok, list(String.t())} | {:error, String.t()}
  def of_rna(""), do: {:ok, []}
  def of_rna(rna) do
    String.split(rna, ~r/.{3}/, include_captures: true, trim: true) |> do_of_rna([])
  end

  defp do_of_rna([head | tail], acc) do
    case of_codon(head) do
      {:error, _} -> {:error, "invalid RNA"}
      {:ok, "STOP"} -> do_of_rna([], acc)
      {:ok, protein} -> do_of_rna(tail, [protein | acc])
    end
  end
  defp do_of_rna([], acc), do: {:ok, Enum.reverse(acc)}

  @doc """
  Given a codon, return the corresponding protein

  UGU -> Cysteine
  UGC -> Cysteine
  UUA -> Leucine
  UUG -> Leucine
  AUG -> Methionine
  UUU -> Phenylalanine
  UUC -> Phenylalanine
  UCU -> Serine
  UCC -> Serine
  UCA -> Serine
  UCG -> Serine
  UGG -> Tryptophan
  UAU -> Tyrosine
  UAC -> Tyrosine
  UAA -> STOP
  UAG -> STOP
  UGA -> STOP
  """
  @codons %{
    "Methionine" => ["AUG"],
    "Phenylalanine" => ["UUU", "UUC"],
    "Leucine" => ["UUA", "UUG"],
    "Serine" => ["UCU", "UCC", "UCA", "UCG"],
    "Tyrosine" => ["UAU", "UAC"],
    "Cysteine" => ["UGU", "UGC"],
    "Tryptophan" => ["UGG"],
    "STOP" => ["UAA", "UAG", "UGA"],
  }

  @spec of_codon(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def of_codon(codon) do
    case translate_to_protein(codon) do
      nil -> {:error, "invalid codon"}
      {protein, _} -> {:ok, protein}
    end
  end

  defp translate_to_protein(codon), do: @codons |> Enum.find(fn {_k, v} -> codon in v end)
end
