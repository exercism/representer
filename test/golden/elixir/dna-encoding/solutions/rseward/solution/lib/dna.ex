defmodule DNA do
  def encode_nucleotide(code_point) do
    # Please implement the encode_nucleotide/1 function
    case code_point do
      ?\s -> 0b0000
      ?A -> 0b0001
      ?C -> 0b0010
      ?G -> 0b0100
      ?T -> 0b1000
    end
  end

  def decode_nucleotide(encoded_code) do
    # Please implement the decode_nucleotide/1 function

    case encoded_code do
      0b0000 -> ?\s
      0b0001 -> ?A
      0b0010 -> ?C
      0b0100 -> ?G
      0b1000 -> ?T
    end
  end

  def encode(dna) do
    # Please implement the encode/1 function
    #Enum.map( do_encode(dna), fn x -> <<x::size(4)>> end )
    do_encode(<<>>, dna)
  end

  def do_encode(seq, []), do: seq
  def do_encode(seq, [ first | rest ]) do
    newseq = <<seq::bitstring, encode_nucleotide(first)::size(4)>>
    do_encode(newseq, rest)
  end


  def decode(dna) do
    # Please implement the decode/1 function
    do_decode([],dna)
  end

  def do_decode(seq,mybits) when bit_size(mybits)==0, do: seq
  def do_decode(seq, mybits) do
    <<first::size(4), rest::bitstring>> = mybits
    newseq = seq ++ [ decode_nucleotide(first) ]
    do_decode(newseq, rest)
  end
end
