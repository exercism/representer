include std/sequence.e
include std/map.e

sequence nucl = "ACGT"

public function counts(sequence nucleotides)
  if length(filter(nucleotides, "out", nucl)) > 0 then
    return 0
  end if
  object res = new()
  for i = 1 to 4 do
    atom char = nucl[i]
    put(res, char, length(retain_all(char, nucleotides)))
  end for
  return res
end function
