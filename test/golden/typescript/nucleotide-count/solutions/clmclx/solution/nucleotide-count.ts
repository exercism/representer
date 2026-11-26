type NucleotidesCount = {
      A: number,
      C: number,
      G: number,
      T: number
    }

export function nucleotideCounts(dnaSequence: string) {
  const validNucleotides = ['A', 'T', 'G', 'C'];
  const nucleotidesCount: NucleotidesCount = {
      A: 0,
      C: 0,
      G: 0,
      T: 0
    }
  dnaSequence.split('').forEach((nucleotide: string) => {
     if (!validNucleotides.includes(nucleotide)) {
      throw new Error("Invalid nucleotide in strand");
    } else {
      type objectKey = keyof typeof nucleotidesCount;
      nucleotidesCount[nucleotide as objectKey]=nucleotidesCount[nucleotide as objectKey] +1;
    }
  })
  return nucleotidesCount;
}
