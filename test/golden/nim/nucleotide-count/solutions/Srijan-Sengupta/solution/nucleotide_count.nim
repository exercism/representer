import tables, sequtils
proc countDna*(dna: string): CountTable[char] =
  if dna.allIt(it in {'A', 'T', 'G', 'C'}):
    return dna.toCountTable()
  else:
    raise ValueError.newException("Please provide A, T, G or C only")
