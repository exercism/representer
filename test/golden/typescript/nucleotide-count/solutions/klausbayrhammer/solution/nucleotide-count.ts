type NucleotideCount = {
  A: number;
  C: number;
  G: number;
  T: number;
}

export function nucleotideCounts(strand: string): NucleotideCount {
  if(strand.match(/[^ACGT]/)) {
    throw new Error('Invalid nucleotide in strand')
  }
  function countNucleotides(nucleotide: string): number {
    return [...strand].filter(e => e === nucleotide).length
  }

  return {
    A: countNucleotides('A'),
    C: countNucleotides('C'),
    G: countNucleotides('G'),
    T: countNucleotides('T'),
  }
}
