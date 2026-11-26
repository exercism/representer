defmodule RnaTranscription do
  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  ## Examples

  iex> RnaTranscription.to_rna('ACTG')
  'UGAC'
  """
  @spec to_rna([char]) :: [char]
  def to_rna(dna) do
    dna
    |> Enum.map(fn x ->
      transcribe(x)
    end)
    |> Enum.to_list()
  end

  def transcribe(?A), do: ?U
  def transcribe(?C), do: ?G
  def transcribe(?T), do: ?A
  def transcribe(?G), do: ?C
end
